class ReturnItemsController < ApplicationController
  before_action :set_return_item, only: %i[ show edit update destroy ]

  # GET /return_items or /return_items.json
  def index
    @return_items = ReturnItem.all
  end

  # GET /return_items/1 or /return_items/1.json
  def show
  end

  # GET /return_items/new
  def new
    @return_item = ReturnItem.new
  end

  # GET /return_items/1/edit
  def edit
  end

  # POST /return_items or /return_items.json
  def create
    @return_item = ReturnItem.new(return_item_params)

    respond_to do |format|
      if @return_item.save
        format.html { redirect_to return_item_url(@return_item), notice: "Return item was successfully created." }
        format.json { render :show, status: :created, location: @return_item }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @return_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /return_items/1 or /return_items/1.json
  def update
    respond_to do |format|
      if @return_item.update(return_item_params)
        format.html { redirect_to return_item_url(@return_item), notice: "Return item was successfully updated." }
        format.json { render :show, status: :ok, location: @return_item }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @return_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /return_items/1 or /return_items/1.json
  def destroy
    @return_item.destroy!

    respond_to do |format|
      format.html { redirect_to return_items_url, notice: "Return item was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_return_item
      @return_item = ReturnItem.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def return_item_params
      params.require(:return_item).permit(:variant_id, :price, :discount, :sum, :quantity, :vat, :return_id)
    end
end
