class EnterItemsController < ApplicationController
  load_and_authorize_resource
  before_action :set_enter_item, only: %i[ show edit update destroy ]

  # GET /enter_items or /enter_items.json
  def index
    @enter_items = EnterItem.all
  end

  # GET /enter_items/1 or /enter_items/1.json
  def show
  end

  # GET /enter_items/new
  def new
    @enter_item = EnterItem.new
  end

  # GET /enter_items/1/edit
  def edit
  end

  # POST /enter_items or /enter_items.json
  def create
    @enter_item = EnterItem.new(enter_item_params)

    respond_to do |format|
      if @enter_item.save
        format.html { redirect_to enter_item_url(@enter_item), notice: "Enter item was successfully created." }
        format.json { render :show, status: :created, location: @enter_item }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @enter_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /enter_items/1 or /enter_items/1.json
  def update
    respond_to do |format|
      if @enter_item.update(enter_item_params)
        format.html { redirect_to enter_item_url(@enter_item), notice: "Enter item was successfully updated." }
        format.json { render :show, status: :ok, location: @enter_item }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @enter_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /enter_items/1 or /enter_items/1.json
  def destroy
    @enter_item.destroy!

    respond_to do |format|
      format.html { redirect_to enter_items_url, notice: "Enter item was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_enter_item
      @enter_item = EnterItem.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def enter_item_params
      params.require(:enter_item).permit(:enter_id, :variant_id, :quantity, :price, :vat, :sum)
    end
end
