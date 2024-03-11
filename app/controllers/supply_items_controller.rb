class SupplyItemsController < ApplicationController
    load_and_authorize_resource
    before_action :set_supply_item, only: %i[ show edit update destroy ]
  
    def new
        @supply_item = SupplyItem.new
    end

    # GET /supply_statuses/1/edit
    def edit
    end

    # POST /supply_statuses or /supply_statuses.json
    def create
        @supply_item = SupplyItem.new(supply_item_params)

        respond_to do |format|
            if @supply_item.save
            format.turbo_stream { flash.now[:success] = t('.success') }
            format.html { redirect_to supply_items_url, notice: t('.success') }
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
            format.turbo_stream { flash.now[:success] = t('.success') }
            format.html { redirect_to supply_items_url, notice: t('.success') }
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
          format.html { redirect_to supply_items_url, notice: "SupplyItem was successfully destroyed." }
          format.json { head :no_content }
          format.turbo_stream { flash.now[:success] = t('.success') }
        end
    end
    
    private

    def set_supply_item
        @supply_item = SupplyItem.find(params[:id])
    end

    def supply_params
        params.require(:supply_item).permit(:warehouse_id, :product_id, :quantity, :price, :sum)
    end  

end