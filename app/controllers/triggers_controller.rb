class TriggersController < ApplicationController
  load_and_authorize_resource
  before_action :set_trigger, only: %i[show edit update destroy]

  # GET /triggers or /triggers.json
  def index
    @search = Trigger.ransack(params[:q])
    @search.sorts = "id desc" if @search.sorts.empty?
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
        format.html { redirect_to triggers_url, notice: t(".success") }
        format.json { render :show, status: :created, location: @trigger }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @trigger.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /triggers/1 or /triggers/1.json
  def update
    puts "======"
    puts trigger_params
    puts "======"
    respond_to do |format|
      if @trigger.update(trigger_params)
        format.html { redirect_to triggers_url, notice: t(".success") }
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
      format.html { redirect_to triggers_url, notice: t(".success") }
      format.json { head :no_content }
    end
  end

  def slimselect_nested_item # GET
    target = params[:turboId]
    action = Action.find_by(id: target.remove("action_"))
    slimselect_name = params[:selected_id]
    p "+++++++"
    p slimselect_name
    p "+++++++"
    child_index = target.remove("action_")

    if action.present?
      p "action.present"
      helpers.fields model: Trigger.new do |f|
        f.fields_for :actions, action do |ff|
          render turbo_stream: turbo_stream.replace(
            target,
            partial: "actions/form_data",
            locals: {f: ff, slimselect_name: slimselect_name, child_index: child_index}
          )
        end
      end
    else
      p "action.present - not"
      helpers.fields model: Trigger.new do |f|
        f.fields_for :actions, Action.new, child_index: child_index do |ff|
          render turbo_stream: turbo_stream.replace(
            target,
            partial: "actions/form_data",
            locals: {f: ff, slimselect_name: slimselect_name, child_index: child_index}
          )
        end
      end
    end
  end

  def new_nested # GET
    child_index = Time.now.to_i
    helpers.fields model: Trigger.new do |f|
      f.fields_for :actions, Action.new, child_index: child_index do |ff|
        render turbo_stream: turbo_stream.append(
          "actions",
          partial: "actions/form_data",
          locals: {f: ff, slimselect_name: nil, child_index: child_index}
        )
      end
    end
  end

  def remove_nested # POST
    Action.find_by(id: params[:action_id]).delete if params[:action_id].present?
    @remove_element = params[:remove_element]
    respond_to do |format|
      format.turbo_stream { flash.now[:notice] = t(".success") }
    end
  end


  private

  # Use callbacks to share common setup or constraints between actions.
  def set_trigger
    @trigger = Trigger.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def trigger_params
    params.require(:trigger).permit(:title, :event, :condition, :pause, :pause_time, :active, actions_attributes: [:id, :trigger_id, :template_id, :action_name, :_destroy, :action_params, action_params: []])
  end
end
