# TriggersController
class TriggersController < ApplicationController
  load_and_authorize_resource
  before_action :set_trigger, only: %i[show edit update destroy]

  def index
    @search = Trigger.ransack(params[:q])
    @search.sorts = 'id desc' if @search.sorts.empty?
    @triggers = @search.result(distinct: true).paginate(page: params[:page], per_page: 100)
  end

  def show
    @actions = @trigger.actions
  end

  def new
    @trigger = Trigger.new
  end

  def edit; end

  def create
    @trigger = Trigger.new(trigger_params)

    respond_to do |format|
      if @trigger.save
        format.html { redirect_to edit_trigger_url(@trigger), notice: t('.success') }
        format.json { render :show, status: :created, location: @trigger }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @trigger.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @trigger.update(trigger_params)
        format.html { redirect_to triggers_url, notice: t('.success') }
        format.json { render :show, status: :ok, location: @trigger }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @trigger.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @check_destroy = @trigger.destroy ? true : false
    message = if @check_destroy == true
                flash.now[:success] = t('.success')
              else
                flash.now[:notice] = @trigger.errors.full_messages.join(' ')
              end

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          render_turbo_flash
        ]
      end
      format.html { redirect_to triggers_url, notice: t('.success') }
      format.json { head :no_content }
    end
  end


  private

  def set_trigger
    @trigger = Trigger.find(params[:id])
  end

  def trigger_params
    params.require(:trigger).permit(:title, :event, :condition, :pause, :pause_time, :active, actions_attributes: [:id, :trigger_id, :name, :value, :_destroy])
  end
end
