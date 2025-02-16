# EntersController < ApplicationController
class EntersController < ApplicationController
  load_and_authorize_resource
  before_action :set_enter, only: %i[ show edit update destroy ]
  include SearchQueryRansack
  include DownloadExcel
  include NestedItem

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
        @enter.enter_items.build(variant_id: inc.variant.id, quantity: inc.quantity, price: inc.price)
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
        format.html { redirect_to enters_url, notice: t('.success') }
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
        format.html { redirect_to enters_url, notice: t('.success') }
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
      format.html { redirect_to enters_url, notice: 'Enter was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_enter
      @enter = Enter.find(params[:id])
    end

    def enter_params
      params.require(:enter).permit(:enter_status_id, :title, :date, :warehouse_id, :manager_id, :stock_transfer_id,
      enter_items_attributes: [:id, :variant_id, :enter_id, :quantity, :price, :vat, :sum, :_destroy])
    end
    
end
