class SupplyStatusesController < ApplicationController
  load_and_authorize_resource
  before_action :set_supply_status, only: %i[show edit update destroy]

  # GET /supply_statuses or /supply_statuses.json
  def index
    # @supply_statuses = SupplyStatus.all
    @search = SupplyStatus.ransack(params[:q])
    @search.sorts = "position asc" if @search.sorts.empty?
    @supply_statuses = @search.result(distinct: true).paginate(page: params[:page], per_page: 100)
  end

  # GET /supply_statuses/1 or /supply_statuses/1.json
  def show
  end

  # GET /supply_statuses/new
  def new
    @supply_status = SupplyStatus.new
  end

  # GET /supply_statuses/1/edit
  def edit
  end

  # POST /supply_statuses or /supply_statuses.json
  def create
    @supply_status = SupplyStatus.new(supply_status_params)

    respond_to do |format|
      if @supply_status.save
        flash.now[:success] = t(".success")
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update(SupplyStatus.new, ''),
            render_turbo_flash
          ]
        end
        format.html { redirect_to supply_statuses_url, notice: t(".success") }
        format.json { render :show, status: :created, location: @supply_status }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @supply_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /supply_statuses/1 or /supply_statuses/1.json
  def update
    respond_to do |format|
      if @supply_status.update(supply_status_params)
        flash.now[:success] = t(".success")
        format.turbo_stream do
          render turbo_stream: [
            render_turbo_flash
          ]
        end
        format.html { redirect_to supply_statuses_url, notice: t(".success") }
        format.json { render :show, status: :ok, location: @supply_status }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @supply_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /supply_statuses/1 or /supply_statuses/1.json
  def destroy
    # @supply_status.destroy
    @check_destroy = @supply_status.destroy ? true : false
    message = if @check_destroy == true
                flash.now[:success] = t(".success")
              else
                flash.now[:notice] = @supply_status.errors.full_messages.join(" ")
              end

    respond_to do |format|
      format.html { redirect_to supply_statuses_url, notice: "Supply status was successfully destroyed." }
      format.json { head :no_content }
      format.turbo_stream { message }
    end
  end

  def sort
    @supply_status.insert_at params[:new_position]
    head :ok
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_supply_status
    @supply_status = SupplyStatus.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def supply_status_params
    params.require(:supply_status).permit(:title, :color, :position)
  end
end
