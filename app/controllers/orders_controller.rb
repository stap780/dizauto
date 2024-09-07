class OrdersController < ApplicationController
  load_and_authorize_resource
  before_action :set_order, only: %i[show edit update destroy]
  include SearchQueryRansack

  def index
    @search = Order.ransack(search_params)
    @search.sorts = "id desc" if @search.sorts.empty?
    @orders = @search.result(distinct: true).paginate(page: params[:page], per_page: 100)
    respond_to do |format|
      format.html
    end
  end

  def download
    # puts "########### search_params download => #{search_params}"
    if params[:download_type] == "selected" && !params[:product_ids].present?
      flash.now[:error] = "Выберите позиции"
      render turbo_stream: [
        render_turbo_flash
      ]
    else
      collection_ids = params[:product_ids] if params[:download_type] == "selected" && params[:product_ids].present?
      collection_ids = Order.ransack(search_params).result(distinct: true).pluck(:id) if params[:download_type] == "filtered"
      collection_ids = Order.all.pluck(:id) if params[:download_type] == "all"
      CreateZipXlsxJob.perform_later(collection_ids, {model: "Order",current_user_id: current_user.id} )
      render turbo_stream: 
        turbo_stream.update(
          'modal',
          template: "shared/pending_bulk"
        )
    end
  end

  def show
  end

  def new
    @order = Order.new
    @order.order_items.build
  end

  def edit
    @commentable = @order
  end

  def create
    @order = Order.new(order_params)

    respond_to do |format|
      if @order.save
        format.html { redirect_to orders_url, notice: t(".success") }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to orders_url, notice: t(".success") }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @order.destroy

    respond_to do |format|
      format.turbo_stream { flash.now[:success] = t(".success") }
      format.html { redirect_to orders_url, notice: t(".success") }
      format.json { head :no_content }
    end
  end

  def bulk_print # post
    if params[:order_ids]
      templ_id = params[:button].split("#").last
      BulkPrintJob.perform_later("Order", params[:order_ids], templ_id, current_user.id)
      render turbo_stream: 
        turbo_stream.update(
          'modal',
          template: "shared/pending_bulk"
        )
    else
      notice = "Выберите позиции"
      redirect_to orders_url, alert: notice
    end
  end

  def slimselect_nested_item # GET
    target = params[:turboId]
    order_item = OrderItem.find_by(id: target.remove("order_item_"))
    product = Order.find(params[:selected_id])
    child_index = target.remove("order_item_")

    if order_item.present?
      helpers.fields model: Order.new do |f|
        f.fields_for :order_items, order_item do |ff|
          render turbo_stream: turbo_stream.replace(
            target,
            partial: "order_items/form_data",
            locals: {f: ff, product: product, child_index: child_index}
          )
        end
      end
    else
      helpers.fields model: Order.new do |f|
        f.fields_for :order_items, OrderItem.new, child_index: child_index do |ff|
          render turbo_stream: turbo_stream.replace(
            target,
            partial: "order_items/form_data",
            locals: {f: ff, product: product, child_index: child_index}
          )
        end
      end
    end
  end

  def new_nested # GET
    child_index = Time.now.to_i
    helpers.fields model: Order.new do |f|
      f.fields_for :order_items, OrderItem.new, child_index: child_index do |ff|
        render turbo_stream: turbo_stream.append(
          "order_items",
          partial: "order_items/form_data",
          locals: {f: ff, product: nil, child_index: child_index}
        )
      end
    end
  end

  def remove_nested # POST
    OrderItem.find_by(id: params[:order_item_id]).delete if params[:order_item_id].present?
    @remove_element = params[:remove_element]
    respond_to do |format|
      format.turbo_stream { flash.now[:notice] = t(".success") }
    end
  end

  private
  # information - @commentable - as separate folder controllers/orders/comments_controller.rb

  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:company_id,:order_status_id, :client_id, :manager_id, :payment_type_id, :delivery_type_id,
      order_items_attributes: [:id, :product_id, :price, :discount, :sum, :quantity, :_destroy], comments_attributes: [:id, :commentable_type, :commentable_id, :user_id, :body, :_destroy])
  end

end
