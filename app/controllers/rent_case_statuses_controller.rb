class RentCaseStatusesController < ApplicationController
  load_and_authorize_resource
  before_action :set_rent_case_status, only: %i[show edit update destroy]

  # GET /rent_case_statuses or /rent_case_statuses.json
  def index
    @search = RentCaseStatus.ransack(params[:q])
    @search.sorts = "position asc" if @search.sorts.empty?
    @rent_case_statuses = @search.result(distinct: true).paginate(page: params[:page], per_page: 100)
  end

  # GET /rent_case_statuses/1 or /rent_case_statuses/1.json
  def show
  end

  # GET /rent_case_statuses/new
  def new
    @rent_case_status = RentCaseStatus.new
  end

  # GET /rent_case_statuses/1/edit
  def edit
  end

  # POST /rent_case_statuses or /rent_case_statuses.json
  def create
    @rent_case_status = RentCaseStatus.new(rent_case_status_params)

    respond_to do |format|
      if @rent_case_status.save
        format.turbo_stream { flash.now[:success] = t(".success") }
        format.html { redirect_to rent_case_status_url(@rent_case_status), notice: "Rent case status was successfully created." }
        format.json { render :show, status: :created, location: @rent_case_status }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @rent_case_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rent_case_statuses/1 or /rent_case_statuses/1.json
  def update
    respond_to do |format|
      if @rent_case_status.update(rent_case_status_params)
        format.turbo_stream { flash.now[:success] = t(".success") }
        format.html { redirect_to rent_case_status_url(@rent_case_status), notice: "Rent case status was successfully updated." }
        format.json { render :show, status: :ok, location: @rent_case_status }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @rent_case_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rent_case_statuses/1 or /rent_case_statuses/1.json
  def destroy
    @rent_case_status.destroy

    respond_to do |format|
      format.html { redirect_to rent_case_statuses_url, notice: "Rent case status was successfully destroyed." }
      format.json { head :no_content }
      format.turbo_stream { flash.now[:success] = t(".success") }
    end
  end

  def sort
    @rent_case_status.insert_at params[:new_position]
    head :ok
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_rent_case_status
    @rent_case_status = RentCaseStatus.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def rent_case_status_params
    params.require(:rent_case_status).permit(:title, :color, :position)
  end
end
