class PropsController < ApplicationController
    load_and_authorize_resource
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
    end
  
    # PATCH/PUT /properties/1 or /properties/1.json
    def update
      if @prop.update(prop_params) 
        flash.now[:success] = 'prop updated!'
      else
        render :edit
      end
    end
  
    # DELETE /properties/1 or /properties/1.json
    def destroy
      @prop.destroy
      flash.now[:success] = 'prop deleted!'
    end
    
    def characteristics
      @target = params[:target]
      @wraptarget = params[:wraptarget]
      @targetname = params[:targetname]
      # puts '@target =>'+@target.to_s
      # puts 'params[:property_id] =>'+params[:property_id].to_s
      @property = Property.includes(:characteristics).find(params[:property_id])
      @characteristics = [] #@property.characteristics.pluck(:title, :id)
      respond_to do |format|
        format.turbo_stream
      end
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
  