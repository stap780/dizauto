
class Product::ImportImage

    require 'open-uri'
    require "addressable/uri"
    require "image_processing/mini_magick"

    #  FileUtils.rm_rf(Dir["#{Rails.public_path}/test_img/*"])
    #  FileUtils.rm_rf(Dir["#{Rails.public_path}/import_img/*"])

    def initialize(product_id, images)
        @product = Product.find(product_id)
        @images = images
        @images_attributes = Array.new
        @tmp_folder_path = Rails.env.development? ? "#{Rails.public_path}/import_img/#{@product.id.to_s}/" : "/var/www/dizauto/shared/public/import_img/#{@product.id.to_s}/"
    end

    def call
        # create_tmp_folder
        io_image
        add_images_to_product
        # clear_tmp_folder
    end

    private
    
    def create_tmp_folder
        FileUtils.mkdir_p(@tmp_folder_path)
    end

    def io_image
        product_images_filenames = @product.images.map{|im| im.file.filename.base}
        puts "======"
        puts product_images_filenames.to_s
        @images.each_with_index do |link, index|
            filename = File.basename(link)
            check_name = File.basename(link).split('.').first
            have_new_filename = !product_images_filenames.include?(check_name)
            
            if have_new_filename
                hash = Hash.new
                # temp_file_name = @product.id.to_s+"_"+(index+1).to_s+File.extname(link)
                new_link = normalize_link_download_image_file(link)#, temp_file_name)
                
                images_have_position_like_index = @product.images.pluck(:position).include?(index+1)
                
                if images_have_position_like_index
                    position = nil  # because we have validate_image_position callback
                else
                    position = index + 1
                end

                # hash[:position] = position
                #     file_data_hash = Hash.new
                #     file_data_hash[:io] = File.open(new_link)
                #     file_data_hash[:filename] = filename
                # hash[:file] = file_data_hash

                blob = ActiveStorage::Blob.create_and_upload!( io: File.open(new_link), filename: filename )
                hash[:file] = blob.signed_id
                hash[:position] = position

                @images_attributes.push(hash)
            end
        end
    end

    def add_images_to_product
        @product.update!(images_attributes: @images_attributes) if  @images_attributes.present?
    end

    def clear_tmp_folder
        FileUtils.rm_rf(Dir[@tmp_folder_path+"*"])
    end

    def normalize_link_download_image_file(url)#, temp_file_name)
        clear_url = Addressable::URI.parse(url).normalize

        #image_path = @tmp_folder_path+temp_file_name

        # if File.file?(image_path).present?
        #   image_path
        # else
          begin
              file = URI.open(clear_url.to_s)
            rescue OpenURI::HTTPError
              puts  'normalize_download_image_file OpenURI::HTTPError'
              puts clear_url
              file = nil
            rescue Net::OpenTimeout
              puts 'normalize_download_image_file Net::OpenTimeout'
              puts clear_url
              file = nil
            else
            #   tempfile = ImageProcessing::MiniMagick.source(file.path).saver!(quality: 78)
            #   IO.copy_stream(tempfile, image_path)
            #   files_for_testing_volume(file.path, temp_file_name) if Rails.env.development?
            #   image_path
            tempfile = ImageProcessing::MiniMagick.source(file.path).saver!(quality: 75)
          end
        # end
    end


    def files_for_testing_volume(file_path, filename)
        # save original image to check volume for first 100 product pcs
        IO.copy_stream(file_path, "#{Rails.public_path}/test_img/#{filename}")
    end

end

          # product.update!(images_attributes: [{file: blob.signed_id}, {file: blob1.signed_id}])
          # product.update!(images_attributes: images_data)

        # images_data.each do |data|
        #     Image.create!(product_id: data[:product_id], position: data[:position], file: { io: File.open(data[:file]), filename: data[:filename] })
        #     File.delete(data[:file]) if File.file?(data[:file]).present?
        # end
        # MyModel.create!(video: { io: File.open('some/path'), filename: 'video.webm' })
        # image.file.attach(blob_signed_id)
        # image.file.attach(io: File.open(image_path), filename: filename)
        # Image.find(image).file.attach(io: File.open(image_path), filename: filename)

                  # saved_images_name = product.images.map{|image| image.file.filename.to_s}
          # images_data = Array.new
          # index = 1
          # images.each do |url|
          #     filename = File.basename(url)
          #     # if !saved_images_name.include?(filename)
          #     file = normalize_link_download_image_file(url, filename)
          #     if file
          #       image_hash = Hash.new
          #       # image = product.images.create!
          #       # tempfile = ImageProcessing::MiniMagick.source(file.path).saver!(quality: 78)
          #       # blob = ActiveStorage::Blob.create_and_upload!( io: tempfile, filename: filename )
          #       # image.file.attach(blob.signed_id)
          #       # image = product.images.create!(file: blob.signed_id)
          #       # image_path = IO.copy_stream(tempfile, "#{Rails.public_path}/import_img/#{filename}") #we can't use tmp file later in job                      
          #       # AttachImageJob.set(wait: 2.seconds).perform_later(image, blob.signed_id)
          #       # blob = ActiveStorage::Blob.create_and_upload!( io: File.open(file), filename: filename )
          #       # image_hash[:file] = blob.signed_id
          #       # image_hash[:position] = index
          #       # images_data.push(image_hash)
                
          #       # image_hash[:product_id] = product.id
          #       # image_hash[:file] = file
          #       # image_hash[:filename] = filename
          #       # image_hash[:position] = index
          #       # images_data.push(image_hash)
          #       # Image.create!(product_id: product.id, position: index, file: { io: File.open(file), filename: filename })
          #       # index = index + 1
          #     end
          #     # end
          # end
          # puts images_data

