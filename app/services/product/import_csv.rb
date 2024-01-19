class Product::ImportCsv
    require 'open-uri'
    require "addressable/uri"
    require 'roo'
    require "image_processing/mini_magick"

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
    end

    private

    def load_main_file
        download = URI.open(@url)
        File.delete(@download_path) if File.file?(@download_path)
        IO.copy_stream(download, @download_path)
    end

    def collect_data
        spreadsheet = Roo::CSV.new(@download_path, csv_options: {encoding: Encoding::UTF_8})
        header = spreadsheet.row(1)

        @properties = header.map{|h| h.remove('Параметр:').squish if h.include?("Параметр:")}.reject(&:blank?)
        
        job_last_row = @last_row.present? ? @last_row : spreadsheet.last_row
        last_row = Rails.env.development? ? 100 : job_last_row

        (2..last_row).each do |i|
            row = Hash[[header, spreadsheet.row(i)].transpose]
            @file_data.push(row)
        end
    end

    def create_properties
        @properties.each do |property|
            Property.find_or_create_by!(title: property)
        end
    end

    def create_update_products
        @file_data.each do |data|
            pr_data = {
                        barcode: data["Артикул"],
                        sku: data["Параметр: Артикул производителя"],
                        title: data["Название товара"],
                        description: data["Краткое описание"],
                        quantity: data["Остаток"],
                        costprice: data["costprice"],
                        price: data["Цена продажи"],
                        video: data["video"]
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
            images = data["Изображения"].to_s.present? ? data["Изображения"].split(' ') : nil
            saved_images_name = product.images.map{|image| image.file.filename.to_s}
            images.each do |url|
                filename = File.basename(url)
                if !saved_images_name.include?(filename)
                    file = normalize_download_image_file(url, filename)
                    if file
                        tempfile = ImageProcessing::MiniMagick.source(file.path).saver!(quality: 85)
                        blob = ActiveStorage::Blob.create_and_upload!( io: tempfile, filename: filename )
                        image = product.images.create!
                        image.file.attach(blob.signed_id)
                    end
                end
            end
      
            props_for_create = []
            properties = data.select{|k,v| k.include?('Параметр:')}
      
            properties.each do |pro|
              # puts "pro => "+pro.to_s
              p_hash = Hash.new
              # puts "p => "+p.to_s
              if pro[0].present? && pro[1].present?
                s_p = Property.find_or_create_by!( title: pro[0].remove('Параметр:').squish )
                s_char = s_p.characteristics.find_or_create_by!( title: pro[1])
                # puts "s_char => "+s_char.inspect.to_s
                p_hash['property_id'] = s_p.id
                p_hash['characteristic_id'] = s_char.id
              end
              # puts "p_hash => "+p_hash.to_s
              props_for_create.push(p_hash) if p_hash.present?
            end
            
            # puts "props_for_create => "+props_for_create.to_s
            props_for_create.each_with_index do |prop_hash, index|
              product.props.find_or_create_by!(prop_hash) #if index < 2
            end
      
          end
    end

    def normalize_download_image_file(url, filename)
        clear_url = Addressable::URI.parse(url).normalize
        begin
            file = URI.open(clear_url)
          rescue OpenURI::HTTPError
            puts  'normalize_download_image_file OpenURI::HTTPError'
            puts clear_url
            file = nil
          rescue Net::OpenTimeout
            puts 'normalize_download_image_file Net::OpenTimeout'
            puts clear_url
            file = nil
          else
            files_for_testing_volume(file.path, filename) if Rails.env.development?
            file
        end
    end

    def files_for_testing_volume(file_path, filename)
        # save original image to check volume for first 100 product pcs
        #download = URI.open(clear_url)
        IO.copy_stream(file_path, "#{Rails.public_path}/test_img/#{filename}")
    end

end