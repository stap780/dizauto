# PlacesController < ApplicationController
class PlacesController < ApplicationController
  load_and_authorize_resource
  before_action :set_warehouse
  before_action :set_place, only: %i[show edit update destroy]

  include ActionView::RecordIdentifier

  def index
    @places = @warehouse.places
  end

  def show; end

  def new
    @place = @warehouse.places.build
  end

  def edit; end

  def create
    @place = @warehouse.places.build(place_params)

    respond_to do |format|
      if @place.save
        flash.now[:success] = t('.success')
        format.turbo_stream do
          render turbo_stream: [
            render_turbo_flash
          ]
        end
        format.html { redirect_to place_url(@place), notice: 'Place was successfully created.' }
        format.json { render :show, status: :created, location: @place }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @place.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @place.update(place_params)
        flash.now[:success] = t('.success')
        format.turbo_stream do
          render turbo_stream: [
            render_turbo_flash
          ]
        end
        format.html { redirect_to place_url(@place), notice: 'Place was successfully updated.' }
        format.json { render :show, status: :ok, location: @place }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @place.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @place.destroy

    respond_to do |format|
      format.turbo_stream { flash.now[:success] = t('.success') }
      format.html { redirect_to places_url, notice: 'Place was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_warehouse
    @warehouse = Warehouse.find(params[:warehouse_id])
  end

  def set_place
    @place = @warehouse.places.find(params[:id])
  end

  def place_params
    params.require(:place).permit(:sector, :cell, :barcode, :warehouse_id)
  end
end
