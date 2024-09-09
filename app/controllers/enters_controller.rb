class EntersController < ApplicationController
  load_and_authorize_resource
  before_action :set_enter, only: %i[ show edit update destroy ]
  include SearchQueryRansack
  include DownloadExcel

  def index
    @search = Enter.ransack(search_params)
    @search.sorts = "id desc" if @search.sorts.empty?
    @enters = @search.result(distinct: true).paginate(page: params[:page], per_page: 100)
    respond_to do |format|
      format.html
    end
  end

  def show
  end

  def new
    if params[:stock_transfer_id].present?
      stock_transfer = StockTransfer.find(params[:stock_transfer_id])
      @enter = Enter.new(manager_id: current_user.id, warehouse_id: stock_transfer.destination_warehouse_id, stock_transfer_id: params[:stock_transfer_id])
      items = stock_transfer.stock_transfer_items
      items.each do |inc|
        @enter.enter_items.build(product_id: inc.product.id, quantity: inc.quantity, price: inc.price)
      end
    else
      @enter = Enter.new
      @enter.enter_items.build
    end
  end

  def edit
  end

  def create
    @enter = Enter.new(enter_params)

    respond_to do |format|
      if @enter.save
        format.html { redirect_to enters_url, notice: t(".success") }
        format.json { render :show, status: :created, location: @enter }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @enter.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @enter.update(enter_params)
        format.html { redirect_to enters_url, notice: t(".success") }
        format.json { render :show, status: :ok, location: @enter }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @enter.errors, status: :unprocessable_entity }
      end
    end
  end

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
    def set_enter
      @enter = Enter.find(params[:id])
    end

    def enter_params
      params.require(:enter).permit(:enter_status_id, :title, :date, :warehouse_id, :manager_id, :stock_transfer_id,
      enter_items_attributes: [:id, :product_id, :enter_id, :quantity, :price, :vat, :sum, :_destroy])
    end
    
end
