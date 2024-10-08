class StockTransfersController < ApplicationController
  load_and_authorize_resource
  before_action :set_stock_transfer, only: %i[ show edit update destroy ]
  include SearchQueryRansack
  include DownloadExcel

  def index
    @search = StockTransfer.ransack(search_params)
    @search.sorts = "id desc" if @search.sorts.empty?
    @stock_transfers = @search.result(distinct: true).paginate(page: params[:page], per_page: 100)
    respond_to do |format|
      format.html
    end
  end

  def show
  end

  def new
    @stock_transfer = StockTransfer.new
  end

  def edit
  end

  def create
    @stock_transfer = StockTransfer.new(stock_transfer_params)

    respond_to do |format|
      if @stock_transfer.save
        format.html { redirect_to stock_transfers_url, notice: t(".success") }
        format.json { render :show, status: :created, location: @stock_transfer }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @stock_transfer.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @stock_transfer.update(stock_transfer_params)
        format.html { redirect_to stock_transfers_url, notice: t(".success") }
        format.json { render :show, status: :ok, location: @stock_transfer }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @stock_transfer.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @check_destroy = @stock_transfer.destroy ? true : false
    message = if @check_destroy == true
      flash.now[:success] = t(".success")
    else
      flash.now[:notice] = @stock_transfer.errors.full_messages.join(" ")
    end
    respond_to do |format|
      format.html { redirect_to stock_transfers_url, notice: t(".success") }
      format.json { head :no_content }
      format.turbo_stream { message }
    end

  end

  def slimselect_nested_item # GET
    target = params[:turboId]
    stock_transfer_item = StockTransferItem.find_by(id: target.remove("stock_transfer_item_"))
    product = Product.find(params[:selected_id])
    child_index = target.remove("stock_transfer_item_")
    warehouse_id = params[:warehouse_id]

    if stock_transfer_item.present?
      helpers.fields model: StockTransfer.new do |f|
        f.fields_for :stock_transfer_items, stock_transfer_item do |ff|
          render turbo_stream: turbo_stream.replace(
            target,
            partial: "stock_transfer_items/form_data",
            locals: {f: ff, product: product, child_index: child_index, our_dom_id: target, warehouse_id: warehouse_id}
          )
        end
      end
    else
      helpers.fields model: StockTransfer.new do |f|
        f.fields_for :stock_transfer_items, StockTransferItem.new, child_index: child_index do |ff|
          render turbo_stream: turbo_stream.replace(
            target,
            partial: "stock_transfer_items/form_data",
            locals: {f: ff, product: product, child_index: child_index, our_dom_id: target, warehouse_id: warehouse_id}
          )
        end
      end
    end
  end

  def new_nested # GET
    child_index = Time.now.to_i
    helpers.fields model: StockTransfer.new do |f|
      f.fields_for :stock_transfer_items, StockTransferItem.new, child_index: child_index do |ff|
        render turbo_stream: turbo_stream.append(
          "stock_transfer_items",
          partial: "stock_transfer_items/form_data",
          locals: {f: ff, product: nil, our_dom_id: "stock_transfer_item_#{child_index}_stock_transfer", warehouse_id: nil}
        )
      end
    end
  end

  def remove_nested # POST
    StockTransferItem.find_by(id: params[:stock_transfer_item_id]).delete if params[:stock_transfer_item_id].present?
    @remove_element = params[:remove_element]
    respond_to do |format|
      format.turbo_stream { flash.now[:notice] = t(".success") }
    end
  end

  private
    def set_stock_transfer
      @stock_transfer = StockTransfer.find(params[:id])
    end

    def stock_transfer_params
      params.require(:stock_transfer).permit(:stock_transfer_status_id, :origin_warehouse_id, :destination_warehouse_id,
      stock_transfer_items_attributes: [:id, :product_id, :stock_transfer_id, :quantity, :price, :vat, :sum, :_destroy])
    end
end
