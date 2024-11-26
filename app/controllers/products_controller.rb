class ProductsController < ApplicationController
  load_and_authorize_resource
  before_action :set_product, only: %i[show edit copy update destroy delete_image sort_image reorder_image update_image]
  include SearchQueryRansack
  include DownloadExcel
  include BulkDelete

  def index
    @search = Product.includes(:props, :variants, images: [:file_attachment, :file_blob]).ransack(search_params)
    @search.sorts = "id desc" if @search.sorts.empty?
    @products = @search.result(distinct: true).paginate(page: params[:page], per_page: Rails.env.development? ? 30 : 100)
    # collection = @search.present? ? @search.result(distinct: true) : @products
    # puts 'collection.count '+collection.count.to_s
    respond_to do |format|
      format.html
      # format.xlsx do
      #   render xlsx: 'products', template: 'products/index', locals: {collection: collection}
      # end
      # format.zip do
      #   CreateZipXlsxJob.perform_later(collection.ids, {  model: "Product",
      #                                                     current_user_id: current_user.id,
      #                                                     filename: filename,
      #                                                     template: "products/index"})
      #   flash[:success] = t ".success"
      #   redirect_back fallback_location: products_path

      #   # This is first example . don't delete
      #   # service = ZipXlsx.new(collection, {filename: filename, template: "products/index"} )
      #   # compressed_filestream = service.call
      #   # send_data compressed_filestream.read, filename: 'products.zip', type: 'application/zip'
      # end
    end
  end

  def search
    if params[:title].present?
      # @search_results = Product.where("title ILIKE ?", "%#{params[:title]}%").map { |p| {title: p.full_title, id: p.id} }.reject(&:blank?)
      @search_results = Variant.ransack(sku_or_barcode_or_product_title_matches_all: "%#{params[:title]}%").result.map { |var| {title: var.full_title, id: var.id} }.reject(&:blank?)
      # puts '==='
      # puts @search_results.to_json.to_s
      render json: @search_results, status: :ok
    else
      render json: @search_results, status: :unprocessable_entity
    end
  end

  def show
    product = Product.find(params[:id])
    render partial: "products/index_image", locals: { product: }
  end

  def new
    @product = Product.new
    @product.variants.build
  end

  def edit
    @product.images.includes([:file_attachment, :file_blob])
    @props = @product.props
    @variants = @product.variants.order(id: :asc)
  end

  def create
    check_positions(params[:product][:images_attributes])
    @product = Product.new(product_params)
    respond_to do |format|
      if @product.save
        format.html { redirect_to edit_product_path(@product), notice: t(".success") }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
        format.turbo_stream do
          render turbo_stream: turbo_stream.update("errors", partial: "shared/errors", locals: {object: @product})
        end
      end
    end
  end

  def bulk_print # post
    if params[:product_ids]
      templ_id = params[:button].split("#").last
      BulkPrintJob.perform_later("Product", params[:product_ids], templ_id, current_user.id)
      render turbo_stream:
        turbo_stream.update(
          "modal",
          template: "shared/pending_bulk"
        )
    else
      notice = "Выберите позиции"
      redirect_to products_url, alert: notice
    end
  end

  def print_etiketki # post
    if params[:product_ids]
      ProductEtiketkiJob.perform_later(params[:product_ids], current_user.id)
      render turbo_stream:
        turbo_stream.update(
          "modal",
          template: "shared/pending_bulk"
        )
    else
      notice = "Выберите товары"
      redirect_to products_url, alert: notice
    end
  end

  def update
    check_positions(params[:product][:images_attributes])
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to products_path, notice: t(".success") }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
        format.turbo_stream do
          render turbo_stream: turbo_stream.update("errors", partial: "shared/errors", locals: {object: @product})
        end
      end
    end
  end

  def copy
    @new_product = @product.dup
    @new_product.title = "(COPY) " + @new_product.title + " - " + Time.now.to_s
    new_props = @product.props.select(:property_id, :characteristic_id).map(&:attributes)
    @new_product.props_attributes = new_props
    new_vars = @product.variants.select(:sku, :price).map(&:attributes)
    @new_product.variants_attributes = new_vars
    respond_to do |format|
      if @new_product.save!
        format.turbo_stream { flash.now[:success] = t(".success") }
        format.html { redirect_to products_path, notice: "Product was successfully created." }
        format.json { render :show, status: :created, location: @new_product }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @new_product.errors, status: :unprocessable_entity }
        format.turbo_stream do
          render turbo_stream: turbo_stream.update("errors", partial: "shared/errors", locals: {object: @new_product})
        end
      end
    end
  end

  def price_edit
    if params[:product_ids]
      @products = Product.where(id: params[:product_ids])
      respond_to do |format|
        format.turbo_stream
      end
    else
      notice = "Выберите позиции"
      redirect_to products_url, alert: notice
    end
  end

  def price_update
    if params[:product_ids]
      field_type = params[:product_price][:field_type]
      move = params[:product_price][:move]
      shift = params[:product_price][:shift]
      points = params[:product_price][:points]
      round = params[:product_price][:round]

      ProductPriceUpdateJob.perform_later(params[:product_ids], field_type, move, shift, points, round, current_user.id)
      render turbo_stream:
        turbo_stream.update(
          "modal",
          partial: "shared/pending_bulk_text"
        )
    else
      notice = "Выберите товары"
      redirect_to products_url, alert: notice
    end
  end

  def destroy
    @product.destroy!
    respond_to do |format|
      flash.now[:success] = t(".success")
      format.turbo_stream do
        render turbo_stream: [
          render_turbo_flash
        ]
      end
      format.html { redirect_to variants_path, status: :see_other, notice: "Variant was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # switch off because we use position input inside form and save position with form save
  def sort_image
    # puts "sort_image params => "+params.to_s
    # @image = @product.images.find_by_id(params[:sort_item_id])
    # @image.insert_at params[:new_position]
    head :ok
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:status, :tip, :sku, :barcode, :title, :description, :quantity, :costprice, :price, :video,
      props_attributes: [:id, :product_id, :property_id, :characteristic_id, :_destroy],
      images_attributes: [:id, :product_id, :position, :file, :_destroy],
      location_attributes: [:id, :product_id, :warehouse_id, :place_id, :_destroy],
      variants_attributes: [:id, :product_id, :sku, :barcode, :quantity, :cost_price, :price, :_destroy])
  end

  def check_positions(images)
    if images.present?
      images.values.each.with_index do |image, index|
        if image["id"]
          image = Image.find(image["id"])
          image.set_list_position(100 + index)
        end
      end
    end
  end

end
