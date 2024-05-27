class LossItemsController < ApplicationController
  load_and_authorize_resource
  before_action :set_loss_item, only: %i[ show edit update destroy ]

  # GET /loss_items or /loss_items.json
  def index
    @loss_items = LossItem.all
  end

  # GET /loss_items/1 or /loss_items/1.json
  def show
  end

  # GET /loss_items/new
  def new
    @loss_item = LossItem.new
  end

  # GET /loss_items/1/edit
  def edit
  end

  # POST /loss_items or /loss_items.json
  def create
    @loss_item = LossItem.new(loss_item_params)

    respond_to do |format|
      if @loss_item.save
        format.html { redirect_to loss_item_url(@loss_item), notice: "Loss item was successfully created." }
        format.json { render :show, status: :created, location: @loss_item }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @loss_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /loss_items/1 or /loss_items/1.json
  def update
    respond_to do |format|
      if @loss_item.update(loss_item_params)
        format.html { redirect_to loss_item_url(@loss_item), notice: "Loss item was successfully updated." }
        format.json { render :show, status: :ok, location: @loss_item }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @loss_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /loss_items/1 or /loss_items/1.json
  def destroy
    @loss_item.destroy!

    respond_to do |format|
      format.html { redirect_to loss_items_url, notice: "Loss item was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_loss_item
      @loss_item = LossItem.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def loss_item_params
      params.require(:loss_item).permit(:loss_id, :product_id, :quantity, :price, :vat, :sum)
    end
end
