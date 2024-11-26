class SupplyItemsController < ApplicationController
  load_and_authorize_resource
  before_action :set_supply
  before_action :set_supply_item, only: %i[show edit update destroy]

  def index
    @supply_items = @supply.supply_items
  end

  def show
  end

  def new
    @supply_item = @supply.supply_items.build
    # child_index = Time.now.to_i
    # helpers.fields model: Supply.new do |f|
    #   f.fields_for :supply_items, @supply_item, child_index: child_index do |ff|
    #     render turbo_stream: turbo_stream.append(
    #       dom_id(@supply, :supply_items),
    #       partial: "supply_items/form_data",
    #       locals: {f: ff, variant: nil, our_dom_id: dom_id(@supply, "supply_item_#{child_index}"), warehouse_id: @supply.warehouse_id}
    #     )
    #   end
    # end
  end

  # GET /supply_statuses/1/edit
  def edit
  end

  # POST /supply_statuses or /supply_statuses.json
  def create
    # @supply_item = SupplyItem.new(supply_item_params)
    @supply_item = @supply.supply_items.build(supply_item_params)

    respond_to do |format|
      if @supply_item.save
        format.turbo_stream { flash.now[:success] = t(".success") }
        format.html { redirect_to supply_items_url, notice: t(".success") }
        format.json { render :show, status: :created, location: @supply_item }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @supply_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /supply_statuses/1 or /supply_statuses/1.json
  def update
    respond_to do |format|
      if @supply_item.update(supply_item_params)
        format.turbo_stream { flash.now[:success] = t(".success") }
        format.html { redirect_to supply_items_url, notice: t(".success") }
        format.json { render :show, status: :ok, location: @supply_item }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @supply_item.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @supply_item.destroy

    respond_to do |format|
      flash.now[:success] = t(".success")
      format.turbo_stream do
        render turbo_stream: [
          # turbo_stream.remove @supply_item,
          render_turbo_flash
        ]
      end
      format.html { redirect_to supply_items_url, notice: "SupplyItem was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_supply
    @supply = Supply.find(params[:supply_id])
  end

  def set_supply_item
    @supply_item = @supply.supply_items.find(params[:id])
  end

  def supply_params
    params.require(:supply_item).permit(:variant_id, :location_id, :quantity, :price, :sum)
  end

end
