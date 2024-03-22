class DeliveryTypesController < ApplicationController
  load_and_authorize_resource
  before_action :set_delivery_type, only: %i[show edit update destroy]

  # GET /deliveries or /deliveries.json
  def index
    @search = DeliveryType.ransack(params[:q])
    @search.sorts = "id desc" if @search.sorts.empty?
    @delivery_types = @search.result(distinct: true).paginate(page: params[:page], per_page: 100)
  end

  # GET /deliveries/1 or /deliveries/1.json
  def show
  end

  # GET /deliveries/new
  def new
    @delivery_type = DeliveryType.new
  end

  # GET /deliveries/1/edit
  def edit
  end

  # POST /deliveries or /deliveries.json
  def create
    @delivery_type = DeliveryType.new(delivery_type_params)

    respond_to do |format|
      if @delivery_type.save
        format.html { redirect_to delivery_types_url, notice: "Delivery was successfully created." }
        format.json { render :show, status: :created, location: @delivery_type }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @delivery_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /deliveries/1 or /deliveries/1.json
  def update
    respond_to do |format|
      if @delivery_type.update(delivery_type_params)
        format.html { redirect_to delivery_types_url, notice: "Delivery was successfully updated." }
        format.json { render :show, status: :ok, location: @delivery_type }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @delivery.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /deliveries/1 or /deliveries/1.json
  def destroy
    @delivery_type.destroy

    respond_to do |format|
      format.html { redirect_to delivery_types_url, notice: "Delivery was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_delivery_type
    @delivery_type = DeliveryType.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def delivery_type_params
    params.require(:delivery_type).permit(:title, :price, :desc)
  end
end
