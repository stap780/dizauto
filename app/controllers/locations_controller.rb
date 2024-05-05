class LocationsController < ApplicationController
  load_and_authorize_resource
  before_action :set_placement
  before_action :set_location, only: %i[ show edit update destroy ]
  include ActionView::RecordIdentifier

  # GET /locations or /locations.json
  def index
    @locations = @placement.locations
  end

  # GET /locations/1 or /locations/1.json
  def show
  end

  # GET /locations/new
  def new
    @location = @placement.locations.build
    @places = params[:warehouse_id].present? ? Warehouse.find_by_id(params[:warehouse_id]).places.map{|p| [p.full_title, p.id]} : []
    child_index = Time.now.to_i
    helpers.fields model: Placement.new do |f|
      f.fields_for :locations, @location, child_index: child_index do |ff|
        render turbo_stream: turbo_stream.append(
          dom_id(@placement, :locations),
          partial: "locations/form_data",
          locals: { f: ff, our_dom_id: dom_id(@placement, "location_#{child_index}") }
        )
      end
    end

  end

  # GET /locations/1/edit
  def edit
    # @places = Warehouse.find_by_id(@location.warehouse_id).places.map{|p| [p.full_title, p.id]}
    # respond_to do |format|
    #   format.turbo_stream do
    #     render turbo_stream: [
    #       turbo_stream.replace( @location, partial: "locations/form", locals: {location: @location, target: @location } )
    #     ]
    #   end
    # end
  end

  # POST /locations or /locations.json
  def create
    @location = Location.new(location_params)

    respond_to do |format|
      if @location.save
        flash.now[:success] = t(".success")
        format.turbo_stream do
          render turbo_stream: [
            render_turbo_flash
          ]
        end
        format.html { redirect_to location_url(@location), notice: "Location was successfully created." }
        format.json { render :show, status: :created, location: @location }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /locations/1 or /locations/1.json
  def update
    respond_to do |format|
      if @location.update(location_params)
        format.html { redirect_to location_url(@location), notice: "Location was successfully updated." }
        format.json { render :show, status: :ok, location: @location }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /locations/1 or /locations/1.json
  def destroy
    @location.destroy!

    respond_to do |format|
      format.html { redirect_to locations_url, notice: "Location was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_placement
      @placement = Placement.find(params[:placement_id])
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_location
      @location = @placement.locations.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def location_params
      params.require(:location).permit(:product_id, :warehouse_id, :place_id)
    end
end
