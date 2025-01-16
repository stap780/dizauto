# TriggerActionsController < ApplicationController
class TriggerActionsController < ApplicationController
  load_and_authorize_resource
  before_action :set_trigger
  before_action :set_trigger_action, only: %i[show edit update destroy]

  include ActionView::RecordIdentifier

  def index
    @trigger_actions = @trigger.trigger_actions
  end

  def show; end

  def new
    @trigger_action = @trigger.trigger_actions.build
  end

  def edit
    @selected = @trigger_action.name
  end

  def create
    puts '======= create Action'
    puts "params => #{params}"
    @trigger_action = @trigger.trigger_actions.build(trigger_action_params)

    respond_to do |format|
      if @trigger_action.save
        flash.now[:success] = t('.success')
        format.turbo_stream do
          render turbo_stream: [
            render_turbo_flash
          ]
        end
        format.html { redirect_to trigger_actions_url(@trigger_action), notice: 'Action was successfully created.' }
        format.json { render :show, status: :created, location: @trigger_action }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @trigger_action.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @trigger_action.update(trigger_action_params)
        flash.now[:success] = t('.success')
        format.turbo_stream do
          render turbo_stream: [
            render_turbo_flash
          ]
        end
        format.html { redirect_to trigger_action_url(@trigger_action), notice: 'Action was successfully updated.' }
        format.json { render :show, status: :ok, location: @trigger_action }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @trigger_action.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @trigger_action.destroy

    respond_to do |format|
      format.html { redirect_to actions_url, notice: 'Action was successfully destroyed.' }
      format.json { head :no_content }
      format.turbo_stream { flash.now[:success] = t('.success') }
    end
  end

  def values
    @target = params[:turboId]
    @selected = params[:selected_id]
    trigger_action_id = params[:turboId].split('_')[2] unless params[:turboId].include?('new')

    trigger_action = params[:turboId].include?('new') ? @trigger.trigger_actions.build : @trigger.trigger_actions.find(trigger_action_id)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: 
          turbo_stream.replace(
            @target, partial: 'trigger_actions/form', locals: { trigger_action: trigger_action }
          )
      end
    end
  end

  private

  def set_trigger
    @trigger = Trigger.find(params[:trigger_id])
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_trigger_action
    @trigger_action = @trigger.trigger_actions.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def trigger_action_params
    params.require(:trigger_action).permit( :trigger_id, :name, :value)
  end
end
