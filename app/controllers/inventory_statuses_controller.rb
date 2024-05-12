class InventoryStatusesController < ApplicationController
  load_and_authorize_resource
  before_action :set_inventory_status, only: %i[ show edit update destroy ]

  # GET /inventory_statuses or /inventory_statuses.json
  def index
    # @inventory_statuses = InventoryStatus.all
    @search = InventoryStatus.ransack(params[:q])
    @search.sorts = "position asc" if @search.sorts.empty?
    @inventory_statuses = @search.result(distinct: true).paginate(page: params[:page], per_page: 100)
  end

  # GET /inventory_statuses/1 or /inventory_statuses/1.json
  def show
  end

  # GET /inventory_statuses/new
  def new
    @inventory_status = InventoryStatus.new
  end

  # GET /inventory_statuses/1/edit
  def edit
  end

  # POST /inventory_statuses or /inventory_statuses.json
  def create
    @inventory_status = InventoryStatus.new(inventory_status_params)

    respond_to do |format|
      if @inventory_status.save
        flash.now[:success] = t(".success")
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update(InventoryStatus.new, ''),
            render_turbo_flash
          ]
        end
        format.html { redirect_to inventory_statuses_url, notice: "Inventory status was successfully created." }
        format.json { render :show, status: :created, location: @inventory_status }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @inventory_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /inventory_statuses/1 or /inventory_statuses/1.json
  def update
    respond_to do |format|
      if @inventory_status.update(inventory_status_params)
        flash.now[:success] = t(".success")
        format.turbo_stream do
          render turbo_stream: [
            render_turbo_flash
          ]
        end
        format.html { redirect_to inventory_statuses_url, notice: "Inventory status was successfully updated." }
        format.json { render :show, status: :ok, location: @inventory_status }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @inventory_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /inventory_statuses/1 or /inventory_statuses/1.json
  def destroy
    # @inventory_status.destroy!
    @check_destroy = @inventory_status.destroy ? true : false
    message = if @check_destroy == true
                flash.now[:success] = t(".success")
              else
                flash.now[:notice] = @inventory_status.errors.full_messages.join(" ")
              end
    respond_to do |format|
      format.turbo_stream { message }
      format.html { redirect_to inventory_statuses_url, notice: "Inventory status was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def sort
    @inventory_status.insert_at params[:new_position]
    head :ok
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_inventory_status
      @inventory_status = InventoryStatus.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def inventory_status_params
      params.require(:inventory_status).permit(:title, :color, :position)
    end
end
