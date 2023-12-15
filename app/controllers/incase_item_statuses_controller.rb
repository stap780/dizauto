class IncaseItemStatusesController < ApplicationController
  load_and_authorize_resource
  before_action :set_incase_item_status, only: %i[ show edit update sort destroy ]

  # GET /incase_item_statuses or /incase_item_statuses.json
  def index
    @search = IncaseItemStatus.ransack(params[:q])
    @search.sorts = 'position asc' if @search.sorts.empty?
    @incase_item_statuses = @search.result(distinct: true).paginate(page: params[:page], per_page: 100)
  end

  # GET /incase_item_statuses/1 or /incase_item_statuses/1.json
  def show
  end

  # GET /incase_item_statuses/new
  def new
    @incase_item_status = IncaseItemStatus.new
  end

  # GET /incase_item_statuses/1/edit
  def edit
  end

  # POST /incase_item_statuses or /incase_item_statuses.json
  def create
    @incase_item_status = IncaseItemStatus.new(incase_item_status_params)

    respond_to do |format|
      if @incase_item_status.save
        format.turbo_stream { flash.now[:success] = t('.success') }
        format.html { redirect_to incase_item_statuses_url, notice: t('.success') }
        format.json { render :show, status: :created, location: @incase_item_status }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @incase_item_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /incase_item_statuses/1 or /incase_item_statuses/1.json
  def update
    respond_to do |format|
      if @incase_item_status.update(incase_item_status_params)
        format.turbo_stream { flash.now[:success] = t('.success') }
        format.html { redirect_to incase_item_statuses_url, notice: "Incase item status was successfully updated." }
        format.json { render :show, status: :ok, location: @incase_item_status }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @incase_item_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /incase_item_statuses/1 or /incase_item_statuses/1.json
  def destroy
    @incase_item_status.destroy

    respond_to do |format|
      format.html { redirect_to incase_item_statuses_url, notice: "Incase item status was successfully destroyed." }
      format.json { head :no_content }
      format.turbo_stream { flash.now[:success] = t('.success') }
    end
  end

  def sort
    # puts "sort params => "+params.to_s
    # position = @incase_item_status.find_by( position: params[:old_position] )
    @incase_item_status.insert_at params[:new_position]
    head :ok
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_incase_item_status
      @incase_item_status = IncaseItemStatus.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def incase_item_status_params
      params.require(:incase_item_status).permit(:title, :color, :position)
    end
end
