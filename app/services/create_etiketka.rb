class CreateEtiketka < ApplicationService

    
    def initialize(products, options={})
        @products = products
        @save_dir = "#{Rails.public_path}/barcodepdfs"
        @result_file_path = "#{@save_dir}/barcodes.pdf"
        @error_message = "We have error while etiketka create"
        @multi_pdf = CombinePDF.new
    end

    def call
        clear_dir
        @products.each do |product|
            @multi_pdf << CombinePDF.load(create_etiketka(product))
        end
        @multi_pdf.save @result_file_path
        # if @multi_pdf
        #     return true,  @result_file_path
        # else
        #     return false, @error_message
        # end
        blob = ActiveStorage::Blob.create_and_upload!( io: File.open(@result_file_path), filename: 'barcodes.pdf')
        if blob
            return true,  blob
        else
            return false, @error_message
        end            
    end

    private

    def create_etiketka(product)
        save_path = "#{@save_dir}/#{product.id}.pdf"
        pdf = WickedPdf.new.pdf_from_string(
            #ActionController::Base.new.render_to_string( partial:'products/etiketka',locals: {:@product => product}),
            ActionController::Base.new.render_to_string( partial:'products/etiketka', locals: {:product => product}),
            page_height: 41, 
            page_width: 65,
            margin:  { top: 1, bottom:5,left:  1, right: 1 },
            footer:  { font_size: 12, center: 'www.dizauto.ru   84951503437' } 
            )
        s_file = File.open(save_path, 'wb') do |file|
            file << pdf
        end
        s_file.path
    end

    def clear_dir
        FileUtils.rm_rf(Dir["#{@save_dir}/*"])
    end

end