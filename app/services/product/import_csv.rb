class Product::ImportCsv < ApplicationService
  require 'open-uri'
  require 'addressable/uri'

  # FileUtils.rm_rf(Dir["#{Rails.public_path}/test_img/*"])

  def initialize(link_to_file)
    @url = link_to_file
    @filename = @url.split("/").last
    @download_path = Rails.env.development? ? "#{Rails.public_path}/csv/#{@filename}" : "/var/www/dizauto/shared/public/csv/#{@filename}"
    @properties = []
    @file_data = []
    @last_row = nil
  end

  def call
    collect_data
    create_properties
    create_update_products
    # delete_unattached_blobs
  end

  private

  def collect_data
    @properties = CSV.foreach(@download_path, headers: false).take(1).flatten.map { |v| v.remove('Параметр:').squish if v.present? && v.include?('Параметр:') }.reject(&:blank?)

    @file_data = if Rails.env.development?
      CSV.foreach(@download_path, headers: true).take(10).map(&:to_h)
    else
      CSV.foreach(@download_path, headers: true).take(9000).map(&:to_h) # we have 50000pcs and 6 files
    end
    # @file_data = CSV.foreach(@download_path, headers: true).map(&:to_h)
  end

  def create_properties
    @properties.each do |property|
      Property.find_or_create_by!(title: property)
    end
  end

  def create_update_products
    @file_data.each do |data|
      props_data = get_properties(data)
      images = data['Изображения'].to_s.present? ? data['Изображения'].split(' ') : nil

      pr_data = {
        barcode: data['Артикул'],
        sku: data['Параметр: Артикул производителя'],
        title: data['Название товара'],
        description: data['Краткое описание'],
        # quantity: data['Остаток'].to_i, # кол-во это отдельный бизнес процесс (оприходование) поэтому здесь выключено
        cost_price: data['costprice'],
        price: data['Цена продажи'],
        video: data['video'],
        props_attributes: props_data,
        images: images
      }
      puts "pr_data => #{pr_data}"
      ProductContentSaveJob.perform_later(pr_data)
    end
  end

  def get_properties(data)
    properties = data.select { |k, v| k.present? && k.include?('Параметр:') && !k.include?('Параметр: Артикул производителя') }
    props_data = []
    if properties.present?
      properties.each do |pro|
        if pro[0].present? && pro[1].present?
          s_p = Property.where(title: pro[0].remove('Параметр:').squish).first_or_create!
          s_char = Characteristic.where(property_id: s_p.id, title: pro[1]).first_or_create!
          p_hash = {}
          p_hash['property_id'] = s_p.id
          p_hash['characteristic_id'] = s_char.id
          props_data.push(p_hash)
        end
      end
    end
    props_data
  end

  def delete_unattached_blobs
    ActiveStorage::Blob.unattached.each(&:purge_later)
    # ActiveStorage::Blob.unattached.each(&:purge)
  end

end
