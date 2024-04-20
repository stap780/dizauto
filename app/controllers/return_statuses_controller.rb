class ReturnStatusesController < ApplicationController
  load_and_authorize_resource
  before_action :set_return_status, only: %i[ show edit update sort destroy ]

  # GET /return_statuses or /return_statuses.json
  def index
    @search = ReturnStatus.ransack(params[:q])
    @search.sorts = "position asc" if @search.sorts.empty?
    @return_statuses = @search.result(distinct: true).paginate(page: params[:page], per_page: 100)
  end

  # GET /return_statuses/1 or /return_statuses/1.json
  def show
  end

  # GET /return_statuses/new
  def new
    @return_status = ReturnStatus.new
  end

  # GET /return_statuses/1/edit
  def edit
  end

  # POST /return_statuses or /return_statuses.json
  def create
    @return_status = ReturnStatus.new(return_status_params)

    respond_to do |format|
      if @return_status.save
        flash.now[:success] = t(".success")
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update(ReturnStatus.new, ''),
            render_turbo_flash
          ]
        end
        format.html { redirect_to return_status_url(@return_status), notice: "Return status was successfully created." }
        format.json { render :show, status: :created, location: @return_status }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @return_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /return_statuses/1 or /return_statuses/1.json
  def update
    respond_to do |format|
      if @return_status.update(return_status_params)
        flash.now[:success] = t(".success")
        format.turbo_stream do
          render turbo_stream: [
            render_turbo_flash
          ]
        end
        format.html { redirect_to return_status_url(@return_status), notice: "Return status was successfully updated." }
        format.json { render :show, status: :ok, location: @return_status }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @return_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /return_statuses/1 or /return_statuses/1.json
  def destroy
    # @return_status.destroy!
    @check_destroy = @return_status.destroy ? true : false
    message = if @check_destroy == true
                flash.now[:success] = t(".success")
              else
                flash.now[:notice] = @return_status.errors.full_messages.join(" ")
              end
    respond_to do |format|
      format.html { redirect_to return_statuses_url, notice: "Return status was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def sort
    @return_status.insert_at params[:new_position]
    head :ok
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_return_status
      @return_status = ReturnStatus.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def return_status_params
      params.require(:return_status).permit(:title, :color, :position)
    end
end
