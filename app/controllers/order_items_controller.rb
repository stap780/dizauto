class OrderItemsController < ApplicationController
  load_and_authorize_resource
  before_action :check_params, only: [:destroy]
  before_action :set_order_item, only: %i[show edit update destroy]
  include ActionView::RecordIdentifier

  # GET /order_items or /order_items.json
  def index
    @order_items = OrderItem.all
  end

  # GET /order_items/1 or /order_items/1.json
  def show
  end

  # GET /order_items/new
  def new
    @order_item = OrderItem.new
  end

  # GET /order_items/1/edit
  def edit
  end

  # POST /order_items or /order_items.json
  def create
    @order_item = OrderItem.new(order_item_params)

    respond_to do |format|
      if @order_item.save
        format.html { redirect_to order_item_url(@order_item), notice: "Order item was successfully created." }
        format.json { render :show, status: :created, location: @order_item }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @order_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /order_items/1 or /order_items/1.json
  def update
    respond_to do |format|
      if @order_item.update(order_item_params)
        format.html { redirect_to order_item_url(@order_item), notice: "Order item was successfully updated." }
        format.json { render :show, status: :ok, location: @order_item }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @order_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /order_items/1 or /order_items/1.json
  def destroy
    puts params
    begin
      @order_item = OrderItem.find_by(id: params[:id])
    rescue ActiveRecord::RecordNotFound => e
      @order_item = nil
    end
    remove_element = @order_item.present? ? dom_id(@order_item) : "order_item_#{params[:id]}"
    @order_item.destroy if @order_item.present?
    respond_to do |format|
      flash.now[:success] = t(".success")
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.remove(remove_element),
          render_turbo_flash,
          turbo_stream.append("order_items", partial: 'shared/recalculate_after_remove')
        ]
      end
    end

  end

  private

  def check_params
    puts 'check_params'
  end

  def set_order_item
    check_params
    # begin
    #   @order_item = OrderItem.find_by(id: params[:id])
    # rescue ActiveRecord::RecordNotFound => e
    #   @order_item = nil
    # end
  end

  def order_item_params
    params.require(:order_item).permit(:variant_id, :price, :discount, :sum, :order_id, :quantity)
  end
end
