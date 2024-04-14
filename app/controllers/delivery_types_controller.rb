class DeliveryTypesController < ApplicationController
  load_and_authorize_resource
  before_action :set_delivery_type, only: %i[show edit update sort destroy]

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
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update(DeliveryType.new, ''),
            render_turbo_flash
          ]
        end
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
        flash.now[:success] = t(".success")
        format.turbo_stream do
          render turbo_stream: [
            render_turbo_flash
          ]
        end
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
    # @delivery_type.destroy
    @check_destroy = @delivery_type.destroy ? true : false
    message = if @delivery_type == true
                flash.now[:success] = t(".success")
              else
                flash.now[:notice] = @delivery_type.errors.full_messages.join(" ")
              end
    respond_to do |format|
      format.html { redirect_to delivery_types_url, notice: "Delivery was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def sort
    @delivery_type.insert_at params[:new_position]
    head :ok
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_delivery_type
    @delivery_type = DeliveryType.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def delivery_type_params
    params.require(:delivery_type).permit(:title, :price, :desc, :position)
  end
end
