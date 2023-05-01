class PropsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_prop, only: %i[ show edit update destroy ]
  
    # GET /properties or /properties.json
    def index
        @props = Prop.all
    end
  
    # GET /properties/1 or /properties/1.json
    def show
    end
  
    # GET /properties/new
    def new
      @prop = Prop.new
    end
  
    # GET /properties/1/edit
    def edit
    end
  
    # POST /properties or /properties.json
    def create
      @prop = Prop.new(prop_params)
      if @prop.save
        flash.now[:success] = 'prop created!'
      else
        render :new
      end
      
      # @prop = prop.new(prop_params)
  
      # respond_to do |format|
      #   if @prop.save
      #     format.html { redirect_to properties_url, notice: "prop was successfully created." }
      #     format.json { render :show, status: :created, location: @prop }
      #   else
      #     format.html { render :new, status: :unprocessable_entity }
      #     format.json { render json: @prop.errors, status: :unprocessable_entity }
      #   end
      # end
    end
  
    # PATCH/PUT /properties/1 or /properties/1.json
    def update
      if @prop.update(prop_params) 
        flash.now[:success] = 'prop updated!'
      else
        render :edit
      end
      # respond_to do |format|
      #   if @prop.update(prop_params)
      #     format.html { redirect_to props_url, notice: "prop was successfully updated." }
      #     format.json { render :show, status: :ok, location: @prop }
      #   else
      #     format.html { render :edit, status: :unprocessable_entity }
      #     format.json { render json: @prop.errors, status: :unprocessable_entity }
      #   end
      # end
    end
  
    # DELETE /properties/1 or /properties/1.json
    def destroy
      @prop.destroy
      flash.now[:success] = 'prop deleted!'
      # respond_to do |format|
      #   format.html { redirect_to properties_url, notice: "prop was successfully destroyed." }
      #   format.json { head :no_content }
      # end
    end
  
    private
      # Use callbacks to share common setup or constraints between actions.
      def set_prop
        @prop = Prop.find(params[:id])
      end
  
      # Only allow a list of trusted parameters through.
      def prop_params
        params.require(:prop).permit(:product_id,:property_id,:characteristic_id, :detal_id)
      end
  end
  