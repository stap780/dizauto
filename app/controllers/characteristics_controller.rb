class CharacteristicsController < ApplicationController
  load_and_authorize_resource
  before_action :get_property
  before_action :set_characteristic, only: %i[ show edit update destroy ]

  # GET /characteristics or /characteristics.json
  def index
    # @characteristics = Characteristic.all
    @characteristics = @property.characteristics
  end

  # GET /characteristics/1 or /characteristics/1.json
  def show
  end

  # GET /characteristics/new
  def new
    @characteristic = @property.characteristics.build
  end

  # GET /characteristics/1/edit
  def edit
  end

  # POST /characteristics or /characteristics.json
  def create
    puts "params => "+params.to_s
    puts "params property_id => "+params['property_id'].to_s
    @characteristic = @property.characteristics.build(characteristic_params)
    puts "characteristic => "+@characteristic.inspect
    respond_to do |format|
      if @characteristic.save
        format.html { redirect_to property_url(@property), notice: "Characteristic was successfully created." }
        format.json { render :show, status: :created, location: @characteristic }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @characteristic.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /characteristics/1 or /characteristics/1.json
  def update
    respond_to do |format|
      if @characteristic.update(characteristic_params)
        format.html { redirect_to property_url(@property), notice: "Characteristic was successfully updated." }
        format.json { render :show, status: :ok, location: @characteristic }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @characteristic.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /characteristics/1 or /characteristics/1.json
  def destroy
    @characteristic.destroy

    respond_to do |format|
      format.html { redirect_to property_url(@property), notice: "Characteristic was successfully destroyed." }
      format.json { head :no_content }
    end
  end
 
  private

  def get_property
    @property = Property.find(params[:property_id]) if params[:property_id].present?
  end

    # Use callbacks to share common setup or constraints between actions.
    def set_characteristic
      @characteristic = @property.characteristics.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def characteristic_params
      params.require(:characteristic).permit(:title, :property_id)
    end
end
