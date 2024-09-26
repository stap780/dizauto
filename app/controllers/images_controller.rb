class ImagesController < ApplicationController
  load_and_authorize_resource
  before_action :set_image, only: %i[edit update destroy]

  require "image_processing/vips"
  include Rails.application.routes.url_helpers

  def index
    @search = Image.ransack(params[:q])
    @search.sorts = "id desc" if @search.sorts.empty?
    # @products = @search.result(distinct: true).includes(images_attachments: :blob).paginate(page: params[:page], per_page: Rails.env.development? ? 10 : 100)
    @images = @search.result(distinct: true).paginate(page: params[:page], per_page: Rails.env.development? ? 30 : 100)
    respond_to do |format|
      format.html
    end
  end

  def show
  end

  def new
    @image = Image.new
  end

  def edit
  end

  def create
    @image = Image.new(image_params)
    respond_to do |format|
      if @image.save
        format.html { redirect_to images_path, notice: "Image was successfully created." }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  def upload
    params.require(:blob_signed_id)
    signed_id = params["blob_signed_id"]
    upload_blob = ActiveStorage::Blob.find_signed(signed_id)
    filename = upload_blob.filename
    content_type = upload_blob.content_type

    # This is use when we save image to Disk storage
    # upload_image_path = ActiveStorage::Blob.service.send(:path_for, upload_blob.key)
    # magick_image_path = ImageProcessing::MiniMagick.source(upload_image_path).saver!(quality: 78)
    # new_blob = ActiveStorage::Blob.create_and_upload!(  io: magick_image_path,
    #                                                     filename: filename,
    #                                                     content_type: content_type )

    # This use when we save to S3
    file = upload_blob.open do |tempfile|
      puts "upload_blob ======= upload_blob"
      puts "tempfile.path"
      puts tempfile.path
      ImageProcessing::MiniMagick.source(tempfile.path).saver!(quality: 80)
    end

    new_blob = ActiveStorage::Blob.create_and_upload!(io: file, filename: filename)

    @blob = new_blob

    respond_to do |format|
      format.turbo_stream { flash.now[:notice] = t(".success") }
    end
  end

  # use only for flash message because delete images from product happend while update form
  def delete
    # Fetch the blob using the signed id
    # @blob_signed_id = params[:blob_signed_id]
    # image = params[:image_id].present? ? Image.find(params[:image_id]) : nil
    # blob = ActiveStorage::Blob.find_signed(@blob_signed_id)

    # image.present? ? image.destroy : blob.purge

    # respond_to do |format|
    #   format.turbo_stream { flash.now[:notice] = t(".success") }
    # end
    # im = Image.includes(:file_attachment).where(file_attachment: {blob_id: 24148})
    if params[:blob_signed_ids]
      DeleteImageByBlobSignedIdJob.perform_now(params[:blob_signed_ids], current_user.id)
      respond_to do |format|
        format.turbo_stream{ flash.now[:success] = t(".success") }
      end
    else
      respond_to do |format|
        format.turbo_stream{ flash.now[:success] = t(".choose_images") }
      end
    end
  end

  def destroy
    # if @image.file.attached?
    #   blob = ActiveStorage::Blob.find_signed(@image.file.blob)
    #   blob.purge
    # end
    @image.destroy

    respond_to do |format|
      format.html { redirect_to images_url, notice: t(".success") }
      format.json { head :no_content }
    end
  end

  private

  def set_image
    @image = Image.find(params[:id])
  end

  def image_params
    params.require(:image).permit(:file, :position, :product_id)
  end
end
