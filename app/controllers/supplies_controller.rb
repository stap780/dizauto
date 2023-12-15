class SuppliesController < ApplicationController
  load_and_authorize_resource
  before_action :set_supply, only: %i[ show edit update destroy ]

  # GET /supplies or /supplies.json
  def index
    @search = Supply.includes(:company, :supply_items).ransack(params[:q])
    @search.sorts = 'id desc' if @search.sorts.empty?
    @supplies = @search.result(distinct: true).paginate(page: params[:page], per_page: 100)
    filename = 'supplies.xlsx'
    collection = @search.present? ? @search.result(distinct: true) : @incases
    respond_to do |format|
      format.html
      format.zip do
        service = CreateXlsx.new(collection, {filename: filename, template: "supplies/index"} )
        compressed_filestream = service.call
        send_data compressed_filestream.read, filename: 'supplies.zip', type: 'application/zip'
      end
    end
  end

  # GET /supplies/1 or /supplies/1.json
  def show
  end

  # GET /supplies/new
  def new
    @supply = Supply.new
    @supply.supply_items.build
  end

  # GET /supplies/1/edit
  def edit
  end

  # POST /supplies or /supplies.json
  def create
    @supply = Supply.new(supply_params)

    respond_to do |format|
      if @supply.save
        format.html { redirect_to supply_url(@supply), notice: "Supply was successfully created." }
        format.json { render :show, status: :created, location: @supply }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @supply.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /supplies/1 or /supplies/1.json
  def update
    respond_to do |format|
      if @supply.update(supply_params)
        format.html { redirect_to supply_url(@supply), notice: "Supply was successfully updated." }
        format.json { render :show, status: :ok, location: @supply }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @supply.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /supplies/1 or /supplies/1.json
  def destroy
    @supply.destroy

    respond_to do |format|
      format.html { redirect_to supplies_url, notice: "Supply was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_supply
      @supply = Supply.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def supply_params
      params.require(:supply).permit(:company_id, :title, :in_number, :in_date, :supply_status_id, :manager_id, 
      supply_items_attributes: [:id, :warehouse_id, :product_id, :quantity, :price, :sum, :total, :_destroy])
    end
end
