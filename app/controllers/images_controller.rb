class ImagesController < ApplicationController
    load_and_authorize_resource
    require "image_processing/mini_magick"
    include Rails.application.routes.url_helpers

    def upload
        params.require(:blob_signed_id)
        signed_id = params["blob_signed_id"]
        upload_blob = ActiveStorage::Blob.find_signed(signed_id)
        filename = upload_blob.filename
        content_type = upload_blob.content_type

        #Rails.application.routes.url_helpers.rails_blob_path(image.file, only_path: true)
        upload_image_path = ActiveStorage::Blob.service.send(:path_for, upload_blob.key)
        magick_image_path = ImageProcessing::MiniMagick.source(upload_image_path).saver!(quality: 85)
        new_blob = ActiveStorage::Blob.create_and_upload!(  io: magick_image_path, 
                                                            filename: filename,
                                                            content_type: content_type )

        # @blob = ActiveStorage::Blob.find_signed(params[:blob_signed_id])
        @blob = new_blob
        respond_to do |format|
            format.turbo_stream{flash.now[:notice] = t('.success')}
        end
    end

    # use only for flash message because delete images from product happend while update form
    def delete
        # Fetch the blob using the signed id
        @blob_signed_id = params[:blob_signed_id]
        image = params[:image_id].present? ? Image.find(params[:image_id]) : nil
        blob = ActiveStorage::Blob.find_signed(@blob_signed_id)
        if blob
            if blob.attachments.any?
            # the blob is attached to post record
                blob.attachments.each { |attachment| attachment.purge }
            else
                blob.purge
            end
            
            image.delete if image.present?

            respond_to do |format|
                format.turbo_stream{flash.now[:notice] = t('.success')}
            end
        end
    end

    
end