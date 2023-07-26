class IncaseItemsController < ApplicationController
  load_and_authorize_resource
  before_action :set_incase_item, only: %i[ show edit update destroy ]

  # GET /incase_items or /incase_items.json
  def index
    @incase_items = IncaseItem.all
  end

  # GET /incase_items/1 or /incase_items/1.json
  def show
  end

  # GET /incase_items/new
  def new
    @incase_item = LineItem.new
  end

  # GET /incase_items/1/edit
  def edit
  end

  # POST /incase_items or /incase_items.json
  def create
    @incase_item = IncaseItem.new(incase_item_params)

    respond_to do |format|
      if @incase_item.save
        format.html { redirect_to incase_item_url(@incase_item), notice: "Line item was successfully created." }
        format.json { render :show, status: :created, location: @incase_item }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @incase_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /incase_items/1 or /incase_items/1.json
  def update
    respond_to do |format|
      if @incase_item.update(incase_item_params)
        format.html { redirect_to incase_item_url(@incase_item), notice: "Line item was successfully updated." }
        format.json { render :show, status: :ok, location: @incase_item }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @incase_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /incase_items/1 or /incase_items/1.json
  def destroy
    @incase_item.destroy

    respond_to do |format|
      format.html { redirect_to incase_items_url, notice: "Line item was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_incase_item
      @incase_item = IncaseItem.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def incase_item_params
      params.require(:incase_item).permit(:incase_id, :title, :quantity, :katnumber, :price, :sum, :status)
    end
end
