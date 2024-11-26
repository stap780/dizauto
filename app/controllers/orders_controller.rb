class OrdersController < ApplicationController
  load_and_authorize_resource
  before_action :set_order, only: %i[show edit update destroy]
  include SearchQueryRansack
  include DownloadExcel
  include NestedItem

  def index
    @search = Order.ransack(search_params)
    @search.sorts = "id desc" if @search.sorts.empty?
    @orders = @search.result(distinct: true).paginate(page: params[:page], per_page: 100)
    respond_to do |format|
      format.html
    end
  end

  def show; end

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

  private
  # information - @commentable - as separate folder controllers/orders/comments_controller.rb

  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:company_id,:order_status_id, :client_id, :manager_id, :payment_type_id, :delivery_type_id,
      order_items_attributes: [:id, :variant_id, :price, :discount, :sum, :quantity, :_destroy], 
      comments_attributes: [:id, :commentable_type, :commentable_id, :user_id, :body, :_destroy])
  end

end
