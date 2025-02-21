# DeliveriesController < ApplicationController
class DeliveriesController < ApplicationController
  load_and_authorize_resource
  before_action :set_order
  before_action :set_delivery, only: %i[show edit update destroy]

  def index
    @deliveries = @order.deliveries.order(:id)
  end

  def show; end

  def new
    @delivery = @order.build_delivery
  end

  def edit; end

  def create
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

  def destroy
    @delivery.destroy!

    respond_to do |format|
      format.html { redirect_to deliveries_path, status: :see_other, notice: 'Delivery was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_order
    @order = Order.find(params[:order_id])
  end

  def set_delivery
    @delivery = Delivery.find(params[:id])
  end

  def delivery_params
    params.require(:delivery).permit(:order_id, :delivery_type_id, :price, :vat)
  end
end
