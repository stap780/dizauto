class DetalPropsController < ApplicationController
  load_and_authorize_resource
  before_action :set_detal
  before_action :set_detal_prop, only: %i[ show edit update destroy ]

  # GET /detal_props or /detal_props.json
  def index
    @detal_props = @detal.detal_props  
  end

  # GET /detal_props/1 or /detal_props/1.json
  def show
  end

  # GET /detal_props/new
  def new
    @detal_prop = @detal.detal_props.build
    @characteristics = []
  end

  # GET /detal_props/1/edit
  def edit
    @selected = @detal_prop.property.id
    @characteristics = @detal_prop.property.characteristics.pluck(:title, :id)
  end

  # POST /detal_props or /detal_props.json
  def create
    @detal_prop = @detal.detal_props.build(detal_prop_params)

    respond_to do |format|
      if @detal_prop.save
        flash.now[:success] = t(".success")
        format.turbo_stream do
          render turbo_stream: [
            render_turbo_flash
          ]
        end
        format.html { redirect_to detal_detal_props_url(@detal), notice: "Detal prop was successfully created." }
        format.json { render :show, status: :created, location: @detal_prop }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @detal_prop.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /detal_props/1 or /detal_props/1.json
  def update
    respond_to do |format|
      if @detal_prop.update(detal_prop_params)
        flash.now[:success] = t(".success")
        format.turbo_stream do
          render turbo_stream: [
            render_turbo_flash
          ]
        end
        format.html { redirect_to detal_detal_prop_url(@detal), notice: "Detal prop was successfully updated." }
        format.json { render :show, status: :ok, location: @detal_prop }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @detal_prop.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /detal_props/1 or /detal_props/1.json
  def destroy
    @detal_prop.destroy!

    respond_to do |format|
      format.html { redirect_to detal_props_url, notice: "Detal prop was successfully destroyed." }
      format.json { head :no_content }
      format.turbo_stream { flash.now[:success] = t(".success") }
    end
  end

  def characteristics

    @target = params[:turboId]
    @selected = params[:selected_id]
    @property = Property.includes(:characteristics).find(params[:selected_id])

    detal_prop = params[:turboId].include?('new') ? @detal.detal_props.build : @detal_prop
    
    @characteristics = @property.characteristics.pluck(:title, :id)
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: 
          turbo_stream.replace(
            @target, partial: "detal_props/form", locals: {detal_prop: detal_prop}
          )
      end
    end

  end

  private

    def set_detal
      @detal = Detal.find(params[:detal_id])
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_detal_prop
      @detal_prop = @detal.detal_props.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def detal_prop_params
      params.require(:detal_prop).permit(:detal_id, :property_id, :characteristic_id)
    end
end
