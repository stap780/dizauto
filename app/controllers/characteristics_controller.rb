class CharacteristicsController < ApplicationController
  load_and_authorize_resource
  before_action :get_property
  before_action :set_characteristic, only: %i[show edit update destroy]

  def index
    @characteristics = @property.characteristics
  end

  def show
  end

  def new
    @characteristic = @property.characteristics.build
  end

  def edit
  end

  def create
    puts 'params => ' + params.to_s
    puts 'params property_id => ' + params['property_id'].to_s
    @characteristic = @property.characteristics.build(characteristic_params)
    puts 'characteristic => ' + @characteristic.inspect
    respond_to do |format|
      if @characteristic.save
        format.html { redirect_to property_url(@property), notice: 'Characteristic was successfully created.' }
        format.json { render :show, status: :created, location: @characteristic }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @characteristic.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @characteristic.update(characteristic_params)
        format.html { redirect_to property_url(@property), notice: 'Characteristic was successfully updated.' }
        format.json { render :show, status: :ok, location: @characteristic }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @characteristic.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @check_destroy = @characteristic.destroy ? true : false
    message = if @check_destroy == true
      flash.now[:success] = t('.success')
    else
      flash.now[:notice] = @characteristic.errors.full_messages.join(' ')
    end
    respond_to do |format|
      format.html { redirect_to property_url(@property), notice: 'Characteristic was successfully destroyed.' }
      format.json { head :no_content }
      format.turbo_stream { message }
    end
  end

  def search
    if params[:title].present?
      @search_results = @property.characteristics.where('title ILIKE ?', "%#{params[:title]}%").select(:title, :id)
      render json: @search_results, status: :ok
    else
      render json: @search_results, status: :unprocessable_entity
    end
  end

  private

  def get_property
    @property = Property.find(params[:property_id]) if params[:property_id].present?
  end

  def set_characteristic
    @characteristic = @property.characteristics.find(params[:id])
  end

  def characteristic_params
    params.require(:characteristic).permit(:title, :property_id)
  end
end
