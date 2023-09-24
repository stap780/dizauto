class BulkPrint < ApplicationService

    
    def initialize(items, options={})
        @items = items
        @templ = Templ.find(options[:templ_id])
        @save_dir = "#{Rails.public_path}/bulk_prints"
        @result_file = "#{@save_dir}/barcodes.pdf"
        @error_message = nil
        @multi_pdf = CombinePDF.new
    end

    def call
        clear_dir
        @items.each do |item|
            @multi_pdf << CombinePDF.load(create(item))
        end
        @multi_pdf.save @result_file
        if @multi_pdf
            return true, @result_file
        else
            return false, @error_message
        end        
    end

    private

    def create(item)
        save_path = "#{@save_dir}/#{item.id}.pdf"
        success, pdf = CreatePdf.new(item, {templ: @templ}).call
        pdf if success
    end

    def clear_dir
        FileUtils.rm_rf(Dir["#{@save_dir}/*"])
    end

end