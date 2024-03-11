class SuppliesController < ApplicationController
  load_and_authorize_resource
  before_action :set_supply, only: %i[ show edit update destroy ]

  # GET /supplies or /supplies.json
  def index
    @search = Supply.includes(:company, :supply_items).ransack(params[:q])
    @search.sorts = 'id desc' if @search.sorts.empty?
    @supplies = @search.result(distinct: true).paginate(page: params[:page], per_page: 100)
    filename = 'supplies.xlsx'
    collection = @search.present? ? @search.result(distinct: true) : @incases
    respond_to do |format|
      format.html
      format.zip do
        CreateZipXlsxJob.perform_later( collection.ids, { model: 'Supply',
                                                          current_user_id: current_user.id,
                                                          filename: filename, 
                                                          template: "supplies/index"} )
        flash[:success] = t '.success'
        redirect_to supplies_path
      end
    end
  end

  # GET /supplies/1 or /supplies/1.json
  def show
  end

  # GET /supplies/new
  def new
    @supply = Supply.new
    @supply.supply_items.build
  end

  # GET /supplies/1/edit
  def edit
    # @supply.supply_items.build if @supply.supply_items.count < 1
  end

  # POST /supplies or /supplies.json
  def create
    @supply = Supply.new(supply_params)

    respond_to do |format|
      if @supply.save
        format.html { redirect_to supplies_url, notice: "Supply was successfully created." }
        format.json { render :show, status: :created, location: @supply }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @supply.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /supplies/1 or /supplies/1.json
  def update
    respond_to do |format|
      if @supply.update(supply_params)
        format.html { redirect_to supplies_url, notice: "Supply was successfully updated." }
        format.json { render :show, status: :ok, location: @supply }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @supply.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /supplies/1 or /supplies/1.json
  def destroy
    @supply.destroy

    respond_to do |format|
      format.html { redirect_to supplies_url, notice: "Supply was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def slimselect_nested_item #GET
    target = params[:turboId]
    supply_item = SupplyItem.find_by(id: target.remove('supply_item_'))
    product = Product.find(params[:product_id])
    child_index = target.remove('supply_item_')

    if supply_item.present?
      helpers.fields model: Supply.new do |f|
        f.fields_for :supply_items, supply_item do |ff|
          render turbo_stream: turbo_stream.replace(
            target,
            partial: "supply_items/form_data",
            locals: { f: ff, product: product, child_index: child_index }
          )
        end
      end
    else
      helpers.fields model: Supply.new do |f|
        f.fields_for :supply_items, SupplyItem.new, child_index: child_index do |ff|
          render turbo_stream: turbo_stream.replace(
            target,
            partial: "supply_items/form_data",
            locals: { f: ff, product: product, child_index: child_index }
          )
        end
      end
    end
  end

  def new_nested #GET
    child_index = Time.now.to_i
    helpers.fields model: Supply.new do |f|
      f.fields_for :supply_items, SupplyItem.new, child_index: child_index do |ff|
        render turbo_stream: turbo_stream.append(
          "supply_items",
          partial: "supply_items/form_data",
          locals: { f: ff, product: nil, child_index: child_index}
        )
      end
    end
  end

  def remove_nested #POST
    SupplyItem.find_by(id: params[:supply_item_id]).delete if params[:supply_item_id].present?
    @remove_element = params[:remove_element]
    respond_to do |format|
      format.turbo_stream{flash.now[:notice] = t('.success')}
    end
  end

  private

  def set_supply
    @supply = Supply.find(params[:id])
  end

  def supply_params
    params.require(:supply).permit(:company_id, :title, :in_number, :in_date, :supply_status_id, :manager_id, supply_items_attributes: [:id, :warehouse_id, :product_id, :quantity, :price, :sum, :_destroy])
  end

end
