class PropsController < ApplicationController
  load_and_authorize_resource
  before_action :set_product
  before_action :set_prop, only: %i[show edit update destroy]

  def index
    @props = @product.props
  end

  def show
  end

  def new
    @prop = @product.props.build
    @characteristics = []
  end

  def edit
    @selected = @prop.property.id
    @characteristics = @prop.property.characteristics.pluck(:title, :id)
  end

  def create
    @prop = @product.props.build(prop_params)

    respond_to do |format|
      if @prop.save
        flash.now[:success] = t(".success")
        format.turbo_stream do
          render turbo_stream: [
            render_turbo_flash
          ]
        end
          format.html { redirect_to product_props_path(@product), notice: 'prop was successfully created.' }
          format.json { render :show, status: :created, location: @prop }
      else
          format.html { render :new }
          format.json { render json: @prop.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @prop.update(prop_params)
        flash.now[:success] = t(".success")
        format.turbo_stream do
          render turbo_stream: [
            render_turbo_flash
          ]
        end
        format.html { redirect_to product_prop_path(@product), notice: 'prop was successfully updated.' }
        format.json { render :show, status: :ok, location: @prop }
      else
        format.html { render :edit }
        format.json { render json: @prop.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @prop.destroy
     respond_to do |format|
      format.html { redirect_to product_props_path(@product), notice: 'prop was successfully destroyed.' }
      format.json { head :no_content }
      format.turbo_stream { flash.now[:success] = t(".success") }
    end
  end

  def characteristics

    @target = params[:turboId]
    @selected = params[:selected_id]
    @property = Property.includes(:characteristics).find(params[:selected_id])
    prop_id = params[:turboId].split('_')[1] if !params[:turboId].include?('new')
    prop = params[:turboId].include?('new') ? @product.props.build : @product.props.find(prop_id)
    
    @characteristics = @property.characteristics.pluck(:title, :id)
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: 
          turbo_stream.replace(
            @target, partial: "props/form", locals: {prop: prop}
          )
      end
    end

  end

  private

  def set_product
    @product = Product.find(params[:product_id])
  end
  # Use callbacks to share common setup or constraints between actions.
  def set_prop
    @prop = @product.props.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def prop_params
    params.require(:prop).permit(:product_id, :property_id, :characteristic_id)
  end


end
