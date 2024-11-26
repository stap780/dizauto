class StockTransferItemsController < ApplicationController
  before_action :set_stock_transfer_item, only: %i[ show edit update destroy ]

  # GET /stock_transfer_items or /stock_transfer_items.json
  def index
    @stock_transfer_items = StockTransferItem.all
  end

  # GET /stock_transfer_items/1 or /stock_transfer_items/1.json
  def show
  end

  # GET /stock_transfer_items/new
  def new
    @stock_transfer_item = StockTransferItem.new
  end

  # GET /stock_transfer_items/1/edit
  def edit
  end

  # POST /stock_transfer_items or /stock_transfer_items.json
  def create
    @stock_transfer_item = StockTransferItem.new(stock_transfer_item_params)

    respond_to do |format|
      if @stock_transfer_item.save
        format.html { redirect_to stock_transfer_item_url(@stock_transfer_item), notice: "Stock transfer item was successfully created." }
        format.json { render :show, status: :created, location: @stock_transfer_item }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @stock_transfer_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /stock_transfer_items/1 or /stock_transfer_items/1.json
  def update
    respond_to do |format|
      if @stock_transfer_item.update(stock_transfer_item_params)
        format.html { redirect_to stock_transfer_item_url(@stock_transfer_item), notice: "Stock transfer item was successfully updated." }
        format.json { render :show, status: :ok, location: @stock_transfer_item }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @stock_transfer_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stock_transfer_items/1 or /stock_transfer_items/1.json
  def destroy
    @stock_transfer_item.destroy!

    respond_to do |format|
      format.html { redirect_to stock_transfer_items_url, notice: "Stock transfer item was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_stock_transfer_item
      @stock_transfer_item = StockTransferItem.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def stock_transfer_item_params
      params.require(:stock_transfer_item).permit(:variant_id, :quantity, :price, :vat, :sum)
    end
end
