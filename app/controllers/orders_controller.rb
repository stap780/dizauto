# OrdersController < ApplicationController
class OrdersController < ApplicationController
  load_and_authorize_resource
  before_action :set_order, only: %i[show edit update destroy]
  include SearchQueryRansack
  include DownloadExcel
  include NestedItem
  include BulkStatus


  def index
    @search = Order.ransack(search_params)
    @search.sorts = 'id desc' if @search.sorts.empty?
    @orders = @search.result(distinct: true).paginate(page: params[:page], per_page: 100)
    respond_to do |format|
      format.html
    end
  end

  def show; end

  def new
    @order = Order.new
    @order.order_items.build
    @order.shippings.build
    @order.comments.build
    @order.build_delivery
  end

  def edit
    @commentable = @order
    @order.build_delivery if @order.delivery.nil?
  end

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

  def destroy
    @order.destroy

    respond_to do |format|
      format.turbo_stream { flash.now[:success] = t('.success') }
      format.html { redirect_to orders_url, notice: t('.success') }
      format.json { head :no_content }
    end
  end

  def bulk_print # post
    if params[:order_ids]
      templ_id = params[:button].split('#').last
      BulkPrintJob.perform_later('Order', params[:order_ids], templ_id, current_user.id)
      render turbo_stream: 
        turbo_stream.update(
          'modal',
          template: 'shared/pending_bulk'
        )
    else
      notice = 'Выберите позиции'
      redirect_to orders_url, alert: notice
    end
  end

  def delivery
    selected = DeliveryType.find(params[:selected_id])
    order_id = params[:turboId].split('_').last.to_i
    item = order_id.positive? ? Order.find(order_id)&.delivery : nil
    puts "delivery selected => #{selected.to_json}"
    target = params[:turboId]

    helpers.fields model: Order.new do |f|
      f.fields_for :delivery, item.present? ? item : Delivery.new do |ff|
        render turbo_stream: [
          turbo_stream.update(
            target,
            partial: 'deliveries/form_data',
            locals: { f: ff, dtid: selected.id, vat: 0, price: selected.price }
          ),
          turbo_stream.append(target, partial: 'shared/recalculate')
        ]
      end
    end
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(
      :seller_id,
      :company_id,
      :order_status_id,
      :client_id,
      :manager_id,
      :payment_type_id,
      order_items_attributes: %i[id variant_id price vat discount sum quantity _destroy],
      shippings_attributes: [:id,:name,:phone,:address,:date,:time_from,:time_to,:order_id,:_destroy,
        comments_attributes: %i[id commentable_type commentable_id user_id body _destroy]
      ],
      comments_attributes: %i[id commentable_type commentable_id user_id body _destroy],
      delivery_attributes: %i[id order_id delivery_type_id price vat _destroy]
      )
  end

end
