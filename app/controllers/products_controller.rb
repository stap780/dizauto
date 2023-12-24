class ProductsController < ApplicationController
  load_and_authorize_resource
  before_action :set_product, only: %i[ show edit update destroy delete_image reorder_image update_image ]

  # GET /products or /products.json
  def index
    @search = Product.ransack(params[:q])
    @search.sorts = 'id desc' if @search.sorts.empty?
    @products = @search.result(distinct: true).paginate(page: params[:page], per_page: 100)
    filename = 'products.xlsx'
    collection = @search.present? ? @search.result(distinct: true) : @products
    # puts 'collection.count '+collection.count.to_s
    respond_to do |format|
      format.html
      format.zip do
        service = CreateXlsx.new(collection, {filename: filename, template: "products/index"} )
        compressed_filestream = service.call
        send_data compressed_filestream.read, filename: 'products.zip', type: 'application/zip'
      end
    end
  end

  def search
    index
  end
  
  # GET /products/1 or /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
    @props = @product.props
  end

  # POST /products or /products.json
  def create
    @product = Product.new(product_params)
    respond_to do |format|
      if @product.save
        format.html { redirect_to products_path, notice: "Product was successfully created." }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
        format.turbo_stream do
          render turbo_stream: turbo_stream.update('errors', partial: 'shared/errors', locals: { object: @product})
        end
      end
    end
  end

  def characteristics
    @target = params[:target]
    puts @target
    @property = Property.find(params[:property_id])
    @characteristics = @property.characteristics.pluck(:title, :id)
    respond_to do |format|
      format.turbo_stream
    end
  end

  def print
    templ = Templ.find(params[:templ_id])
    success, pdf = CreatePdf.new(@product, {templ: templ}).call
    if success
      send_file pdf, type: 'application/pdf', disposition: 'attachment'
    else
      alert = 'Ошибка в файле печати: '+pdf.to_s
      redirect_to products_url, notice: alert
    end
  end

  def print_etiketki #post
    if params[:product_ids]
      ProductEtiketkiJob.perform_later(params[:product_ids], current_user.id)
    else
      notice = 'Выберите товары'
      redirect_to products_url, alert: notice
    end
  end

  def pending_etiketki #get
  end

  def success_etiketki #get
  end

  # PATCH/PUT /products/1 or /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to products_path, notice: "Product was successfully updated." }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
        format.turbo_stream do
          render turbo_stream: turbo_stream.update('errors', partial: 'shared/errors', locals: { object: @product})
        end  
      end
    end
  end

  # DELETE /products/1 or /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: "Product was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def image_import
    @product.update(product_params)
    flash.now[:success] = "update image"
  end
  
  def delete_image
    ActiveStorage::Attachment.where(id: params[:image_id])[0].purge
    flash.now[:success] = "delete image"
  end

  def reorder_image
    puts "reorder_image params => "+params.to_s
    puts "reorder_image params[:id] => "+params[:id].to_s
    # @product = Product.find(params[:id])
    @image = @product.images.find_by blob_id: params[:sort_item_id]
    @image.insert_at params[:new_position]
    head :ok
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def product_params
      params.require(:product).permit(:sku, :barcode, :title, :description, :quantity, :costprice, :price, :video, images: [], 
                                      images_attachments_attributes: [:id, :position, :_destroy],
                                      props_attributes: [:id,:product_id,:property_id,:characteristic_id, :detal_id, :_destroy])
    end
end
