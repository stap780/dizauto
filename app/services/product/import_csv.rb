class Product::ImportCsv
  require "open-uri"
  require "addressable/uri"

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
    @properties = CSV.foreach(@download_path, headers: false).take(1).flatten.map { |v| v.remove("Параметр:").squish if v.present? && v.include?("Параметр:") }.reject(&:blank?)

    @file_data = if Rails.env.development?
      CSV.foreach(@download_path, headers: true).take(10).map(&:to_h)
    else
      CSV.foreach(@download_path, headers: true).take(10000).map(&:to_h)
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
      images = data["Изображения"].to_s.present? ? data["Изображения"].split(" ") : nil

      pr_data = {
        barcode: data["Артикул"],
        sku: data["Параметр: Артикул производителя"],
        title: data["Название товара"],
        description: data["Краткое описание"],
        quantity: data["Остаток"],
        costprice: data["costprice"],
        price: data["Цена продажи"],
        video: data["video"],
        props_attributes: props_data,
        images: images
      }
      # puts pr_data

      ProductContentSaveJob.perform_later(pr_data)
      # s_product = Product.find_by_barcode(pr_data[:barcode])
      # if s_product
      #   puts 'find product'
      #   s_product.update!(pr_data.except!(:props_attributes)) if s_product.props.present? #for future we need prop update
      #   s_product.update!(pr_data) if !s_product.props.present?
      #   product = s_product
      # else
      #   puts 'create product'
      #   product = Product.create!(pr_data)
      # end

      # puts "product id => "+product.id.to_s
      # puts product.errors.full_messages.to_s if product.errors

      # ProductImageJob.perform_later(product.id, images)

      # clear_tmp_image_folder
    end
  end

  def get_properties(data)
    properties = data.select { |k, v| k.present? && k.include?("Параметр:") && !k.include?("Параметр: Артикул производителя") }
    props_data = []
    if properties.present?
      properties.each do |pro|
        if pro[0].present? && pro[1].present?
          # s_p = Property.find_or_create_by!( title: pro[0].remove('Параметр:').squish )
          s_p = Property.where(title: pro[0].remove("Параметр:").squish).first_or_create!
          # s_char = s_p.characteristics.find_or_create_by!( title: pro[1])
          s_char = Characteristic.where(property_id: s_p.id, title: pro[1]).first_or_create!
          p_hash = {}
          p_hash["property_id"] = s_p.id
          p_hash["characteristic_id"] = s_char.id
          # props_for_create.push(p_hash)
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
