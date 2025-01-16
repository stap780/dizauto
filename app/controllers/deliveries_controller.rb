# DeliveriesController < ApplicationController
class DeliveriesController < ApplicationController
  load_and_authorize_resource
  before_action :set_order
  before_action :set_delivery, only: %i[show edit update destroy]

  def index
    # @deliveries = Delivery.all
    @deliveries = @order.deliveries.order(:id)
  end

  def show; end

  def new
    # @delivery = Delivery.new
    @delivery = @order.build_delivery
  end

  def edit; end

  def create
    # @delivery = Delivery.new(delivery_params)
    @delivery = @order.build_delivery(delivery_params)

    respond_to do |format|
      if @delivery.save
        flash.now[:success] = t('.success')
        format.turbo_stream do
          render turbo_stream: [
            render_turbo_flash
          ]
        end
        format.html { redirect_to @delivery, notice: 'Delivery was successfully created.' }
        format.json { render :show, status: :created, location: @delivery }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @delivery.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /deliveries/1 or /deliveries/1.json
  def update
    respond_to do |format|
      if @delivery.update(delivery_params)
        flash.now[:success] = t('.success')
        format.turbo_stream do
          render turbo_stream: [
            render_turbo_flash
          ]
        end
        format.html { redirect_to @delivery, notice: 'Delivery was successfully updated.' }
        format.json { render :show, status: :ok, location: @delivery }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @delivery.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /deliveries/1 or /deliveries/1.json
  def destroy
    @delivery.destroy!

    respond_to do |format|
      format.html { redirect_to deliveries_path, status: :see_other, notice: 'Delivery was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_product
    @order = Order.find(params[:order_id])
  end
  
  def set_delivery
    @delivery = Delivery.find(params[:id])
  end

  def delivery_params
    params.require(:delivery).permit(:order_id, :delivery_type_id, :price)
  end
end
