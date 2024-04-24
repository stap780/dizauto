class IncaseStatusesController < ApplicationController
  load_and_authorize_resource
  before_action :set_incase_status, only: %i[show edit update sort destroy]

  # GET /incase_statuses or /incase_statuses.json
  def index
    @search = IncaseStatus.ransack(params[:q])
    @search.sorts = "position asc" if @search.sorts.empty?
    @incase_statuses = @search.result(distinct: true).paginate(page: params[:page], per_page: 100)
  end

  # GET /incase_statuses/1 or /incase_statuses/1.json
  def show
  end

  # GET /incase_statuses/new
  def new
    @incase_status = IncaseStatus.new
  end

  # GET /incase_statuses/1/edit
  def edit
  end

  # POST /incase_statuses or /incase_statuses.json
  def create
    @incase_status = IncaseStatus.new(incase_status_params)

    respond_to do |format|
      if @incase_status.save
        flash.now[:success] = t(".success")
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update(IncaseStatus.new, ''),
            render_turbo_flash
          ]
        end
        format.html { redirect_to incase_statuses_url, notice: t(".success") }
        format.json { render :show, status: :created, location: @incase_status }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @incase_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /incase_statuses/1 or /incase_statuses/1.json
  def update
    respond_to do |format|
      if @incase_status.update(incase_status_params)
        flash.now[:success] = t(".success")
        format.turbo_stream do
          render turbo_stream: [
            # turbo_stream.replace(@incase_status, partial: 'incase_statuses/incase_status', locals: { incase_status: @incase_status }),
            render_turbo_flash
          ]
        end
        format.html { redirect_to incase_statuses_url, notice: t(".success") }
        format.json { render :show, status: :ok, location: @incase_status }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @incase_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /incase_statuses/1 or /incase_statuses/1.json
  def destroy
    # @incase_status.destroy
    @check_destroy = @incase_status.destroy ? true : false
    message = if @check_destroy == true
                flash.now[:success] = t(".success")
              else
                flash.now[:notice] = @incase_status.errors.full_messages.join(" ")
              end
    respond_to do |format|
      format.html { redirect_to incase_statuses_url, notice: "Incase status was successfully destroyed." }
      format.json { head :no_content }
      format.turbo_stream { message }
    end
  end

  def sort
    @incase_status.insert_at params[:new_position]
    head :ok
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_incase_status
    @incase_status = IncaseStatus.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def incase_status_params
    params.require(:incase_status).permit(:title, :color, :position)
  end
end
