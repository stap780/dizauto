class PlacementsController < ApplicationController
  load_and_authorize_resource
  before_action :set_placement, only: %i[ show edit update destroy ]

  # GET /placements or /placements.json
  def index
    @search = Placement.ransack(params[:q])
    @search.sorts = "id asc" if @search.sorts.empty?
    @placements = @search.result(distinct: true).paginate(page: params[:page], per_page: 100)
  end

  # GET /placements/1 or /placements/1.json
  def show
  end

  # GET /placements/new
  def new
    @placement = Placement.new(warehouse_id: params[:warehouse_id])
    # @placement.locations.build
  end

  # GET /placements/1/edit
  def edit
    @places = Warehouse.find_by_id(@placement.warehouse_id).places.map{|p| [p.full_title, p.id]}
  end

  # POST /placements or /placements.json
  def create
    @placement = Placement.new(placement_params)

    respond_to do |format|
      if @placement.save
        format.html { redirect_to placements_url, notice: "Placement was successfully created." }
        format.json { render :show, status: :created, location: @placement }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @placement.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /placements/1 or /placements/1.json
  def update
    respond_to do |format|
      if @placement.update(placement_params)
        format.html { redirect_to placements_url, notice: "Placement was successfully updated." }
        format.json { render :show, status: :ok, location: @placement }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @placement.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /placements/1 or /placements/1.json
  def destroy
    @placement.destroy!

    respond_to do |format|
      format.html { redirect_to placements_url, notice: "Placement was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def new_nested # GET
    child_index = Time.now.to_i
    @places = params[:warehouse_id].present? ? Warehouse.find_by_id(params[:warehouse_id]).places.map{|p| [p.full_title, p.id]} : []
    helpers.fields model: Placement.new do |f|
      f.fields_for :locations, Location.new, child_index: child_index do |ff|
        render turbo_stream: turbo_stream.append(
          "locations_placement",
          partial: "locations/form_data",
          locals: {f: ff, product: nil, our_dom_id: "location_#{child_index}_placement", warehouse_id: params[:warehouse_id] }
        )
      end
    end
  end

  def remove_nested # POST
    Location.find_by(id: params[:location_id]).delete if params[:location_id].present?
    @remove_element = params[:remove_element]
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.remove(@remove_element),
          render_turbo_flash
        ]
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_placement
      @placement = Placement.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def placement_params
      params.require(:placement).permit(:warehouse_id, locations_attributes: [:id, :product_id, :place_id, :_destroy, comments_attributes: [:id, :commentable_type, :commentable_id, :user_id, :body, :_destroy]])
    end
end
