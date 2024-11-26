class LossesController < ApplicationController
  load_and_authorize_resource
  before_action :set_loss, only: %i[ show edit update destroy ]
  include SearchQueryRansack
  include DownloadExcel
  include NestedItem

  def index
    @search = Loss.ransack(search_params)
    @search.sorts = "id desc" if @search.sorts.empty?
    @losses = @search.result(distinct: true).paginate(page: params[:page], per_page: 100)
    respond_to do |format|
      format.html
    end
  end

  def show
  end

  def new
    @loss = Loss.new
    if params[:stock_transfer_id].present?
      stock_transfer = StockTransfer.find(params[:stock_transfer_id])
      @loss = Loss.new( manager_id: current_user.id, warehouse_id: stock_transfer.origin_warehouse_id, stock_transfer_id: params[:stock_transfer_id])
      items = stock_transfer.stock_transfer_items
      items.each do |inc|
        @loss.loss_items.build(variant_id: inc.variant.id, quantity: inc.quantity, price: inc.price)
      end
    else
      @loss = Loss.new
      @loss.loss_items.build
    end
  end

  def edit
  end

  def create
    @loss = Loss.new(loss_params)

    respond_to do |format|
      if @loss.save
        format.html { redirect_to losses_url, notice: "Loss was successfully created." }
        format.json { render :show, status: :created, location: @loss }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @loss.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @loss.update(loss_params)
        format.html { redirect_to losses_url, notice: "Loss was successfully updated." }
        format.json { render :show, status: :ok, location: @loss }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @loss.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @loss.destroy!

    respond_to do |format|
      format.html { redirect_to losses_url, notice: "Loss was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_loss
      @loss = Loss.find(params[:id])
    end

    def loss_params
      params.require(:loss).permit(:loss_status_id, :title, :date, :warehouse_id, :manager_id, :stock_transfer_id,
      loss_items_attributes: [:id, :variant_id, :quantity, :price, :vat, :sum, :_destroy])
    end
end
