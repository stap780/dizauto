class Product::ImportCsv
    require 'open-uri'
    require "addressable/uri"

    # FileUtils.rm_rf(Dir["#{Rails.public_path}/test_img/*"])

    def initialize
        @url = "http://138.197.52.153/insales.csv"
        @filename = @url.split('/').last
        @download_path = Rails.env.development? ? "#{Rails.public_path}/#{@filename}" : "/var/www/dizauto/shared/public/#{@filename}"
        @properties = Array.new
        @file_data = Array.new
        @last_row = nil
    end

    def call
        load_main_file
        collect_data
        create_properties
        create_update_products
        delete_unattached_blobs
    end

    private

    def load_main_file
        download = URI.open(@url)
        File.delete(@download_path) if File.file?(@download_path)
        IO.copy_stream(download, @download_path)
    end

    def collect_data
        @properties = CSV.foreach(@download_path, headers: false).take(1).flatten.map{|v| v.remove('Параметр:').squish if v.include?('Параметр:')}.reject(&:blank?)

        if Rails.env.development?
          @file_data = CSV.foreach(@download_path, headers: true).take(50).map(&:to_h)
        else
          @file_data = CSV.foreach(@download_path, headers: true).map(&:to_h)
        end
    end

    def create_properties
        @properties.each do |property|
            Property.find_or_create_by!(title: property)
        end
    end

    def create_update_products
        @file_data.each do |data|

          properties = data.select{|k,v| k.include?('Параметр:')}
          props_data = Array.new
          properties.each do |pro|
            if pro[0].present? && pro[1].present?
              p_hash = Hash.new
              s_p = Property.find_or_create_by!( title: pro[0].remove('Параметр:').squish )
              s_char = s_p.characteristics.find_or_create_by!( title: pro[1])
              p_hash['property_id'] = s_p.id
              p_hash['characteristic_id'] = s_char.id
              #props_for_create.push(p_hash)
              props_data.push(p_hash)
            end
          end


          pr_data = {
                      barcode: data["Артикул"],
                      sku: data["Параметр: Артикул производителя"],
                      title: data["Название товара"],
                      description: data["Краткое описание"],
                      quantity: data["Остаток"],
                      costprice: data["costprice"],
                      price: data["Цена продажи"],
                      video: data["video"],
                      props_attributes: props_data
                    }
          puts pr_data
          s_product = Product.find_by_barcode(pr_data[:barcode])
          if s_product
            s_product.update(pr_data)
            product = s_product
          else
            product = Product.create!(pr_data)
          end
    
          puts "product id => "+product.id.to_s
          puts product.errors.full_messages.to_s if product.errors
          
          images = data["Изображения"].to_s.present? ? data["Изображения"].split(' ') : nil
          ProductImageJob.perform(product.id, images)

          # clear_tmp_image_folder

        end
    end

    def delete_unattached_blobs
      ActiveStorage::Blob.unattached.each(&:purge_later)
      #ActiveStorage::Blob.unattached.each(&:purge)
    end

end