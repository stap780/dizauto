class ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_product, only: %i[ show edit update destroy delete_image reorder_image update_image ]

  # GET /products or /products.json
  def index
    @search = Product.ransack(params[:q])
    @search.sorts = 'id desc' if @search.sorts.empty?
    @products = @search.result(distinct: true).paginate(page: params[:page], per_page: 100)
  end

  # GET /products/1 or /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
    # @product.properties.build
    @props = @product.props
  end

  # GET /products/1/edit
  def edit
    # @product.properties.build
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
      end
    end
  end

  def characteristics
    @target = params[:target]
    @property = Property.find(params[:property_id])
    @characteristics = @property.characteristics.pluck(:title, :id)
    respond_to do |format|
      format.turbo_stream
    end
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

  def update_image
    @product.update(product_params)
    flash.now[:success] = "update image"
    # respond_to do |format|
    #   format.turbo_stream { 
    #     render turbo_stream: turbo_stream.replace("images_product_#{@product.id}",
    #       render_to_string(partial: 'dropzone'))
    #   }

    #   format.html { redirect_back(fallback_location: products_path,  notice: "Создали картинки" ) }
    # end
  end
  
  def delete_image
    ActiveStorage::Attachment.where(id: params[:image_id])[0].purge
    # respond_to do |format|
    #   format.html { redirect_back(fallback_location: products_path,  notice: "Удалили картинки" ) }
    #   format.json { render json: { :status => "ok", :message => "destroyed" } }
    # end
    flash.now[:success] = "delete image"
  end

  def reorder_image
    puts "params => "+params.to_s
    puts "params[:id] => "+params[:id].to_s
    # @product = Product.find(params[:id])
    @image = @product.images.find_by blob_id: params[:blob_id]
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
                                      prop_attributes: [:id,:product_id,:property_id,:characteristic_id, :detal_id, :_destroy])
    end
end
