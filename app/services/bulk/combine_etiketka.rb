module Bulk
  # CombineEtiketka
  class CombineEtiketka  < ApplicationService
    def initialize(variants)
      @variants = variants
      @error_message = []
    end

    def call
      pdf = CombinePDF.new

      @variants.each do |variant|
        success, blob_pdf = Etiketka.call(variant)
        if success
          pdf << CombinePDF.parse(blob_pdf.download)
        else
          @error_message << "Error: #{blob_pdf}"
        end
      end

      combined_pdf = pdf.to_pdf
      blob = ActiveStorage::Blob.create_and_upload!(
        io: StringIO.new(combined_pdf),
        filename: "combined_etiketka_#{Time.now.to_i}.pdf",
        content_type: 'application/pdf'
      )

      if blob
        [true, blob]
      else
        [false, @error_message]
      end

    end

  end
end

# Test
# variants = Variant.order('id').limit(5)
# include Rails.application.routes.url_helpers
# host = Rails.env.development? ? 'http://localhost:3000' : 'https://erp.dizauto.ru'
# success, blob = Bulk::CombineEtiketka.call(variants)
# url = host + rails_blob_path(blob, only_path: true)