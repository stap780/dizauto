class PropertiesController < ApplicationController
  load_and_authorize_resource
  before_action :set_property, only: %i[show edit update destroy]

  # GET /properties or /properties.json
  def index
    # @properties = Property.all
    @search = Property.ransack(params[:q])
    @search.sorts = "id asc" if @search.sorts.empty?
    @properties = @search.result(distinct: true).paginate(page: params[:page], per_page: 100)
  end

  # GET /properties/1 or /properties/1.json
  def show
    @search = @property.characteristics.ransack(params[:q])
    @search.sorts = "id asc" if @search.sorts.empty?
    @characteristics = @search.result(distinct: true).paginate(page: params[:page], per_page: 100)
  end

  # GET /properties/new
  def new
    @property = Property.new
  end

  # GET /properties/1/edit
  def edit
  end

  # POST /properties or /properties.json
  def create
    @property = Property.new(property_params)

    respond_to do |format|
      if @property.save
        format.html { redirect_to properties_url, notice: "Property was successfully created." }
        format.json { render :show, status: :created, location: @property }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @property.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /properties/1 or /properties/1.json
  def update
    respond_to do |format|
      if @property.update(property_params)
        format.html { redirect_to properties_url, notice: "Property was successfully updated." }
        format.json { render :show, status: :ok, location: @property }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @property.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /properties/1 or /properties/1.json
  def destroy
    @check_destroy = @property.destroy ? true : false
    # puts '====='
    # puts @check_destroy
    # puts @property.errors.messages
    # puts '====='
    message = if @check_destroy == true
      flash.now[:success] = t(".success")
    else
      flash.now[:notice] = @property.errors.full_messages.join(" ")
    end
    respond_to do |format|
      format.html { redirect_to properties_url, notice: "Property was successfully destroyed." }
      format.json { head :no_content }
      format.turbo_stream { message }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_property
    @property = Property.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def property_params
    params.require(:property).permit(:title, characteristics_attributes: [:id, :title, :_destroy])
  end
end
