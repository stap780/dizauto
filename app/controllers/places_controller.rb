class PlacesController < ApplicationController
  load_and_authorize_resource
  before_action :set_warehouse
  before_action :set_place, only: %i[show edit update destroy]

  include ActionView::RecordIdentifier

  # GET /places or /places.json
  def index
    @places = Place.all
    @places = @warehouse.places
  end

  # GET /places/1 or /places/1.json
  def show
  end

  # GET /places/new
  def new
    # @place = Place.new
    @place = @warehouse.places.build
  end

  # GET /places/1/edit
  def edit
  end

  # POST /places or /places.json
  def create
    # @place = Place.new(place_params)
    @place = @warehouse.places.build(place_params)

    respond_to do |format|
      if @place.save
        flash.now[:success] = t(".success")
        format.turbo_stream do
          render turbo_stream: [
            render_turbo_flash
          ]
        end        
        format.html { redirect_to place_url(@place), notice: "Place was successfully created." }
        format.json { render :show, status: :created, location: @place }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @place.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /places/1 or /places/1.json
  def update
    respond_to do |format|
      if @place.update(place_params)
        flash.now[:success] = t(".success")
        format.turbo_stream do
          render turbo_stream: [
            render_turbo_flash
          ]
        end
        format.html { redirect_to place_url(@place), notice: "Place was successfully updated." }
        format.json { render :show, status: :ok, location: @place }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @place.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /places/1 or /places/1.json
  def destroy
    @place.destroy

    respond_to do |format|
      format.turbo_stream { flash.now[:success] = t(".success") }
      format.html { redirect_to places_url, notice: "Place was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_warehouse
    @warehouse = Warehouse.find(params[:warehouse_id])
  end
  
  # Use callbacks to share common setup or constraints between actions.
  def set_place
    # @place = Place.find(params[:id])
    @place = @warehouse.places.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def place_params
    params.require(:place).permit(:sector, :cell, :product_id, :warehouse_id)
  end
end
