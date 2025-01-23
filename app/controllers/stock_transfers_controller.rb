# StockTransfersController < ApplicationController
class StockTransfersController < ApplicationController
  load_and_authorize_resource
  before_action :set_stock_transfer, only: %i[ show edit update destroy ]
  include SearchQueryRansack
  include DownloadExcel
  include NestedItem

  def index
    @search = StockTransfer.ransack(search_params)
    @search.sorts = 'id desc' if @search.sorts.empty?
    @stock_transfers = @search.result(distinct: true).paginate(page: params[:page], per_page: 100)
    respond_to do |format|
      format.html
    end
  end

  def show; end

  def new
    @stock_transfer = StockTransfer.new
  end

  def edit; end

  def create
    @stock_transfer = StockTransfer.new(stock_transfer_params)

    respond_to do |format|
      if @stock_transfer.save
        format.html { redirect_to stock_transfers_url, notice: t('.success') }
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
        format.html { redirect_to stock_transfers_url, notice: t('.success') }
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
      flash.now[:success] = t('.success')
    else
      flash.now[:notice] = @stock_transfer.errors.full_messages.join(' ')
    end
    respond_to do |format|
      format.html { redirect_to stock_transfers_url, notice: t('.success') }
      format.json { head :no_content }
      format.turbo_stream { message }
    end
  end

  private

  def set_stock_transfer
    @stock_transfer = StockTransfer.find(params[:id])
  end

  def stock_transfer_params
    params.require(:stock_transfer).permit(:stock_transfer_status_id, :origin_warehouse_id, :destination_warehouse_id,
    stock_transfer_items_attributes: [:id, :variant_id, :stock_transfer_id, :quantity, :price, :vat, :sum, :_destroy])
  end
end
