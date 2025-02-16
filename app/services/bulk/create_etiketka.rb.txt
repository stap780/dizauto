# BulkCreateEtiketka < ApplicationService
class Bulk::CreateEtiketka < ApplicationService
  def initialize(products, options = {})
    @products = products
    @save_dir = "#{Rails.public_path}/barcodepdfs"
    @result_file_path = "#{@save_dir}/barcodes.pdf"
    @error_message = 'We have error while create etiketka'
    @multi_pdf = CombinePDF.new
  end

  def call
    clear_dir
    @products.each do |product|
      product.variants.each do |variant|
        @multi_pdf << CombinePDF.load(create_etiketka(variant))
      end
    end
    @multi_pdf.save @result_file_path
    blob = ActiveStorage::Blob.create_and_upload!(io: File.open(@result_file_path), filename: 'barcodes.pdf')
    if blob
      [true, blob]
    else
      [false, @error_message]
    end
  end

  private

  def create_etiketka(variant)
    save_path = "#{@save_dir}/#{variant.id}.pdf"
    pdf = WickedPdf.new.pdf_from_string(
      ActionController::Base.new.render_to_string(partial: 'products/etiketka', locals: { variant: variant }),
      page_height: 41,
      page_width: 65,
      margin: {top: 1, bottom: 5, left: 1, right: 1},
      footer: { font_size: 12, center: 'www.dizauto.ru   84951503437' }
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
