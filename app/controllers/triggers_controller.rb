class TriggersController < ApplicationController
  load_and_authorize_resource
  before_action :set_trigger, only: %i[ show edit update destroy ]

  # GET /triggers or /triggers.json
  def index
    @search = Trigger.ransack(params[:q])
    @search.sorts = 'id desc' if @search.sorts.empty?
    @triggers = @search.result(distinct: true).paginate(page: params[:page], per_page: 100)
  end

  # GET /triggers/1 or /triggers/1.json
  def show
  end

  # GET /triggers/new
  def new
    @trigger = Trigger.new
  end

  # GET /triggers/1/edit
  def edit
  end

  # POST /triggers or /triggers.json
  def create
    @trigger = Trigger.new(trigger_params)

    respond_to do |format|
      if @trigger.save
        format.html { redirect_to triggers_url, notice: "Trigger was successfully created." }
        format.json { render :show, status: :created, location: @trigger }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @trigger.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /triggers/1 or /triggers/1.json
  def update
    respond_to do |format|
      if @trigger.update(trigger_params)
        format.html { redirect_to triggers_url, notice: "Trigger was successfully updated." }
        format.json { render :show, status: :ok, location: @trigger }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @trigger.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /triggers/1 or /triggers/1.json
  def destroy
    @trigger.destroy

    respond_to do |format|
      format.html { redirect_to triggers_url, notice: "Trigger was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_trigger
      @trigger = Trigger.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def trigger_params
      params.require(:trigger).permit(:title, :event, :condition, :pause, :pause_time, :active, actions_attributes: [:id, :trigger_id, :template_id, :action_name, :_destroy, action_params: [] ])
    end
end
