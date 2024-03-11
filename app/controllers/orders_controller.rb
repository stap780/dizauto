class OrdersController < ApplicationController
  load_and_authorize_resource
  before_action :set_order, only: %i[ show edit update destroy ]

  # GET /orders or /orders.json
  def index
    @search = Order.ransack(params[:q])
    @search.sorts = 'id desc' if @search.sorts.empty?
    @orders = @search.result(distinct: true).paginate(page: params[:page], per_page: 100)
    filename = 'orders.xlsx'
    collection = @search.present? ? @search.result(distinct: true) : @orders
    respond_to do |format|
      format.html
      format.zip do
        CreateZipXlsxJob.perform_later( collection.ids, { model: 'Order',
                                                          current_user_id: current_user.id,
                                                          filename: filename, 
                                                          template: "orders/index"} )
        flash[:success] = t '.success'
        redirect_to orders_path
      end
    end
  end

  # GET /orders/1 or /orders/1.json
  def show
  end

  # GET /orders/new
  def new
    @order = Order.new
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders or /orders.json
  def create
    @order = Order.new(order_params)

    respond_to do |format|
      if @order.save
        format.html { redirect_to orders_url, notice: t('.success') }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orders/1 or /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to orders_url, notice: t('.success') }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1 or /orders/1.json
  def destroy
    @order.destroy

    respond_to do |format|
      format.html { redirect_to orders_url, notice: t('.success') }
      format.json { head :no_content }
    end
  end


  def print
    templ = Templ.find(params[:templ_id])
    success, pdf = CreatePdf.new(@order, {templ: templ}).call
    if success
      send_file pdf, type: 'application/pdf', disposition: 'attachment'
    else
      alert = 'Ошибка в файле печати: '+pdf.to_s
      redirect_to incases_url, notice: alert
    end
  end

  def slimselect_nested_item #GET
    target = params[:turboId]
    order_item = OrderItem.find_by(id: target.remove('order_item_'))
    product = Product.find(params[:product_id])
    child_index = target.remove('order_item_')

    if order_item.present?
      helpers.fields model: Order.new do |f|
        f.fields_for :order_items, order_item do |ff|
          render turbo_stream: turbo_stream.replace(
            target,
            partial: "order_items/form_data",
            locals: { f: ff, product: product, child_index: child_index }
          )
        end
      end
    else
      helpers.fields model: Order.new do |f|
        f.fields_for :order_items, OrderItem.new, child_index: child_index do |ff|
          render turbo_stream: turbo_stream.replace(
            target,
            partial: "order_items/form_data",
            locals: { f: ff, product: product, child_index: child_index }
          )
        end
      end
    end
  end

  def new_nested #GET
    child_index = Time.now.to_i
    helpers.fields model: Order.new do |f|
      f.fields_for :order_items, OrderItem.new, child_index: child_index do |ff|
        render turbo_stream: turbo_stream.append(
          "order_items",
          partial: "order_items/form_data",
          locals: { f: ff, product: nil, child_index: child_index}
        )
      end
    end
  end

  def remove_nested #POST
    OrderItem.find_by(id: params[:order_item_id]).delete if params[:order_item_id].present?
    @remove_element = params[:remove_element]
    respond_to do |format|
      format.turbo_stream{flash.now[:notice] = t('.success')}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def order_params
      params.require(:order).permit(:order_status_id, :client_id, :manager_id, :payment_type_id, :delivery_type_id,
      order_items_attributes: [:id,:product_id, :price, :discount, :sum, :quantity, :_destroy] )
    end
end
