class EntersController < ApplicationController
  load_and_authorize_resource
  before_action :set_enter, only: %i[ show edit update destroy ]

  # GET /enters or /enters.json
  def index
    @search = Enter.ransack(params[:q])
    @search.sorts = "id desc" if @search.sorts.empty?
    @enters = @search.result(distinct: true).paginate(page: params[:page], per_page: 100)
  end

  # GET /enters/1 or /enters/1.json
  def show
  end

  # GET /enters/new
  def new
    @enter = Enter.new
    @enter.enter_items.build
  end

  # GET /enters/1/edit
  def edit
  end

  # POST /enters or /enters.json
  def create
    @enter = Enter.new(enter_params)

    respond_to do |format|
      if @enter.save
        format.html { redirect_to enters_url, notice: "Enter was successfully created." }
        format.json { render :show, status: :created, location: @enter }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @enter.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /enters/1 or /enters/1.json
  def update
    respond_to do |format|
      if @enter.update(enter_params)
        format.html { redirect_to enters_url, notice: "Enter was successfully updated." }
        format.json { render :show, status: :ok, location: @enter }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @enter.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /enters/1 or /enters/1.json
  def destroy
    @enter.destroy!

    respond_to do |format|
      format.html { redirect_to enters_url, notice: "Enter was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def slimselect_nested_item # GET
    target = params[:turboId]
    enter_item = EnterItem.find_by(id: target.remove("enter_item_"))
    product = Product.find(params[:selected_id])
    child_index = target.remove("enter_item_")
    warehouse_id = params[:warehouse_id]

    if enter_item.present?
      helpers.fields model: Enter.new do |f|
        f.fields_for :enter_items, enter_item do |ff|
          render turbo_stream: turbo_stream.replace(
            target,
            partial: "enter_items/form_data",
            locals: {f: ff, product: product, child_index: child_index, our_dom_id: target, warehouse_id: warehouse_id}
          )
        end
      end
    else
      helpers.fields model: Enter.new do |f|
        f.fields_for :enter_items, EnterItem.new, child_index: child_index do |ff|
          render turbo_stream: turbo_stream.replace(
            target,
            partial: "enter_items/form_data",
            locals: {f: ff, product: product, child_index: child_index, our_dom_id: target, warehouse_id: warehouse_id}
          )
        end
      end
    end
  end

  def new_nested # GET
    child_index = Time.now.to_i
    helpers.fields model: Enter.new do |f|
      f.fields_for :enter_items, EnterItem.new, child_index: child_index do |ff|
        render turbo_stream: turbo_stream.append(
          "enter_items",
          partial: "enter_items/form_data",
          locals: {f: ff, product: nil, our_dom_id: "enter_item_#{child_index}_enter", warehouse_id: nil}
        )
      end
    end
  end

  def remove_nested # POST
    EnterItem.find_by(id: params[:enter_item_id]).delete if params[:enter_item_id].present?
    @remove_element = params[:remove_element]
    respond_to do |format|
      format.turbo_stream { flash.now[:notice] = t(".success") }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_enter
      @enter = Enter.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def enter_params
      params.require(:enter).permit(:enter_status_id, :title, :date, :warehouse_id, :manager_id,
      enter_items_attributes: [:id, :product_id, :quantity, :price, :vat, :sum, :_destroy])
    end
    
end
