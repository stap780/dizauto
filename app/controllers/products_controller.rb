class ProductsController < ApplicationController
  load_and_authorize_resource
  before_action :set_product, only: %i[show edit copy update destroy delete_image sort_image ai_description ai_description_get_task_id]
  include SearchQueryRansack
  include DownloadExcel
  include BulkDelete
  include ActionView::RecordIdentifier

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
      #ProductEtiketkiJob.perform_later(params[:product_ids], current_user.id)
      
      variants_ids = Product.where(id: params[:product_ids]).map(&:variants).flatten.map(&:id)
      ProductEtiketkiJob.perform_later(variants_ids, current_user.id)
    else
      notice = 'Выберите товары'
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
      notice = 'Выберите позиции'
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
          'modal',
          partial: 'shared/pending_bulk_text'
        )
    else
      notice = 'Выберите товары'
      redirect_to products_url, alert: notice
    end
  end

  def ai_description
    prompt = [
      'Напиши описание товара по формуле AIDA для ',
      @product.title,
      ', до 1100 символов, 1 абзац. Используй параметры: ',
      @product.props.map { |p| "#{p.property.title} - #{p.characteristic.title}" }.join(", "),
      'Не пиши про новый товар. Не пиши о назначении товара. Не пиши преймущества использования товара. Не пиши призыв к действию. Не пиши о требованиях эксплуатации. 
Укажи года применения товара. Не используй - качественная замена. Не пиши про кросс номера. Не пиши про гарантию качества. Не пиши про проверку детали. Не пиши про контроль качества.'
    ]  
    @prompt = prompt.join(' ')

    @ai_work = Mitupai.first&.work?
  end

  def ai_description_get_task_id
    @prompt = params[:prompt]
    @model_ai = params[:model_ai]
    task_id = nil
    ai = AiMitup.new
    result = ai.get_task_id(@prompt, @model_ai)
    if result && result['task_id'].present?
      response = [result['message'], "task_id: #{result['task_id']}", 'ожидаем ответа']
      task_id = result['task_id']
    else
      response = [result]
    end
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace(dom_id(@product, 'ai_result_task_id'), partial: 'products/ai/result_task_id', locals: {product: @product, response: response, task_id: task_id} )
        ]
      end
    end
  end

  def ai_description_get_content
    AiGetContentJob.perform_later(@product, params[:task_id], current_user.id)
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update(dom_id(@product, 'ai_result_content'), partial: 'shared/button/running')
        ]
      end
    end
  end

  def ai_description_copy
    helpers.fields model: @product do |f|
      render turbo_stream: [
        turbo_stream.replace(
          dom_id(@product, :description),
          partial: 'products/description',
          locals: { f: f, value: params[:content] }
        )
      ]
    end
  end

  def destroy
    check_destroy = @product.destroy ? true : false
    if check_destroy == true
      flash.now[:success] = t('.success')
    else
      flash.now[:notice] = @product.errors.full_messages.join(' ')
    end
    respond_to do |format|
      format.turbo_stream do
        if check_destroy == true
        render turbo_stream: [
          turbo_stream.remove(dom_id(@product)),
          render_turbo_flash
        ]
        else
          render turbo_stream: [
            render_turbo_flash
          ]
        end
      end
      format.html { redirect_to variants_path, notice: t('.success') }
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