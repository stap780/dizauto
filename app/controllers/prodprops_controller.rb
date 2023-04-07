class ProdpropsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_prodprop, only: %i[ show edit update destroy ]
  
    # GET /properties or /properties.json
    def index
        @prodprops = Prodprop.all
    end
  
    # GET /properties/1 or /properties/1.json
    def show
    end
  
    # GET /properties/new
    def new
      @prodprop = Prodprop.new
    end
  
    # GET /properties/1/edit
    def edit
    end
  
    # POST /properties or /properties.json
    def create
      @prodprop = Prodprop.new(prodprop_params)
      if @prodprop.save
        flash.now[:success] = 'Prodprop created!'
      else
        render :new
      end
      
      # @prodprop = Prodprop.new(prodprop_params)
  
      # respond_to do |format|
      #   if @prodprop.save
      #     format.html { redirect_to properties_url, notice: "prodprop was successfully created." }
      #     format.json { render :show, status: :created, location: @prodprop }
      #   else
      #     format.html { render :new, status: :unprocessable_entity }
      #     format.json { render json: @prodprop.errors, status: :unprocessable_entity }
      #   end
      # end
    end
  
    # PATCH/PUT /properties/1 or /properties/1.json
    def update
      if @prodprop.update(prodprop_params) 
        flash.now[:success] = 'Prodprop updated!'
      else
        render :edit
      end
      # respond_to do |format|
      #   if @prodprop.update(prodprop_params)
      #     format.html { redirect_to prodprops_url, notice: "prodprop was successfully updated." }
      #     format.json { render :show, status: :ok, location: @prodprop }
      #   else
      #     format.html { render :edit, status: :unprocessable_entity }
      #     format.json { render json: @prodprop.errors, status: :unprocessable_entity }
      #   end
      # end
    end
  
    # DELETE /properties/1 or /properties/1.json
    def destroy
      @prodprop.destroy
      flash.now[:success] = 'Prodprop deleted!'
      # respond_to do |format|
      #   format.html { redirect_to properties_url, notice: "prodprop was successfully destroyed." }
      #   format.json { head :no_content }
      # end
    end
  
    private
      # Use callbacks to share common setup or constraints between actions.
      def set_prodprop
        @prodprop = Prodprop.find(params[:id])
      end
  
      # Only allow a list of trusted parameters through.
      def prodprop_params
        params.require(:prodprop).permit(:title,:value,:product_id,:property_id,:characteristic_id)
      end
  end
  