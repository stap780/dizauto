# Bulk::Print < ApplicationService
class Bulk::Print < ApplicationService
  def initialize(items, options = {})
    @items = items
    @templ = Templ.find(options[:templ_id])
    @save_dir = "#{Rails.public_path}/bulk_prints"
    @filename = "#{options[:templ_id]}.pdf"
    @result_file_path = "#{@save_dir}/result_file.pdf"
    @error_message = 'We have error while print create'
    @multi_pdf = CombinePDF.new
  end

  def call
    clear_dir
    @items.each do |item|
      @multi_pdf << CombinePDF.load(create(item))
    end
    @multi_pdf.save @result_file_path

    blob = ActiveStorage::Blob.create_and_upload!(io: File.open(@result_file_path), filename: @filename)
    if blob
      [true, blob]
    else
      [false, @error_message]
    end
  end

  private

  def create(item)
    # save_path = "#{@save_dir}/#{item.id}.pdf"
    success, pdf = CreatePdf.new(item, {templ: @templ}).call
    pdf if success
  end

  def clear_dir
    FileUtils.rm_rf(Dir["#{@save_dir}/*"])
  end

end
