# class Etiketka
class Etiketka < ApplicationService
  def initialize(variant)
    @variant = variant
    @error_message = []
  end

  def call
    pdf = generate_pdf
    blob = upload_pdf(pdf)
    if blob
      [true, blob]
    else
      [false, @error_message]
    end
  end

  private

  def generate_pdf
    WickedPdf.new.pdf_from_string(
      ActionController::Base.new.render_to_string(partial: 'products/etiketka',locals: { variant: @variant }),
      page_height: 41,
      page_width: 65,
      margin: { top: 1, bottom: 5, left: 1, right: 1 },
      footer: { font_size: 12, center: 'www.dizauto.ru   84951503437' },
      encoding: 'UTF-8'
    )
  end

  def upload_pdf(pdf)
    file = Tempfile.new(['etiketka', '.pdf'], encoding: 'ascii-8bit')
    file.write(pdf)
    file.rewind

    blob = ActiveStorage::Blob.create_and_upload!(
      io: file,
      filename: "etiketka_#{@variant.id}.pdf",
      content_type: 'application/pdf'
    )

    file.close
    file.unlink

    blob
  rescue StandardError => e
    @error_message << "Error: #{e.message}"
  end
end

# Test
# variant = Variant.find 444
# include Rails.application.routes.url_helpers
# host = Rails.env.development? ? 'http://localhost:3000' : 'https://erp.dizauto.ru'
# success, blob = Etiketka.call(variant)
# url = host + rails_blob_path(blob, only_path: true)