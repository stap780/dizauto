class EnterStatusesController < ApplicationController
  load_and_authorize_resource
  before_action :set_enter_status, only: %i[ show edit update destroy ]

  # GET /enter_statuses or /enter_statuses.json
  def index
    # @enter_statuses = EnterStatus.all
    @search = EnterStatus.ransack(params[:q])
    @search.sorts = "position asc" if @search.sorts.empty?
    @enter_statuses = @search.result(distinct: true).paginate(page: params[:page], per_page: 100)
  end

  # GET /enter_statuses/1 or /enter_statuses/1.json
  def show
  end

  # GET /enter_statuses/new
  def new
    @enter_status = EnterStatus.new
  end

  # GET /enter_statuses/1/edit
  def edit
  end

  # POST /enter_statuses or /enter_statuses.json
  def create
    @enter_status = EnterStatus.new(enter_status_params)

    respond_to do |format|
      if @enter_status.save
        flash.now[:success] = t(".success")
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update(EnterStatus.new, ''),
            render_turbo_flash
          ]
        end
        format.html { redirect_to enter_statuses_url, notice: "Enter status was successfully created." }
        format.json { render :show, status: :created, location: @enter_status }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @enter_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /enter_statuses/1 or /enter_statuses/1.json
  def update
    respond_to do |format|
      if @enter_status.update(enter_status_params)
        flash.now[:success] = t(".success")
        format.turbo_stream do
          render turbo_stream: [
            render_turbo_flash
          ]
        end
        format.html { redirect_to enter_statuses_url, notice: "Enter status was successfully updated." }
        format.json { render :show, status: :ok, location: @enter_status }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @enter_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /enter_statuses/1 or /enter_statuses/1.json
  def destroy
    # @enter_status.destroy!
    @check_destroy = @enter_status.destroy ? true : false
    message = if @check_destroy == true
                flash.now[:success] = t(".success")
              else
                flash.now[:notice] = @enter_status.errors.full_messages.join(" ")
              end
    respond_to do |format|
      format.turbo_stream { message }
      format.html { redirect_to enter_statuses_url, notice: "Enter status was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def sort
    @enter_status.insert_at params[:new_position]
    head :ok
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_enter_status
      @enter_status = EnterStatus.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def enter_status_params
      params.require(:enter_status).permit(:title, :color, :position)
    end
end
