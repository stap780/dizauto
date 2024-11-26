class VariantsController < ApplicationController
  load_and_authorize_resource
  before_action :set_product
  before_action :set_variant, only: %i[ show edit update destroy ]
  include ActionView::RecordIdentifier

  def index
    @variants = @product.variants.order(:id)
  end

  def show
  end

  def new
    @variant = @product.variants.build
  end

  def edit
  end

  def create
    @variant = @product.variants.build(variant_params)

    respond_to do |format|
      if @variant.save
        flash.now[:success] = t(".success")
        format.turbo_stream do
          render turbo_stream: [
            render_turbo_flash
          ]
        end
        format.html { redirect_to variant_url(@variant), notice: "Variant was successfully created." }
        format.json { render :show, status: :created, location: @variant }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @variant.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @variant.update(variant_params)
        flash.now[:success] = t(".success")
        format.turbo_stream do
          render turbo_stream: [
            render_turbo_flash
          ]
        end
        format.html { redirect_to variant_url(@variant), notice: "Variant was successfully updated." }
        format.json { render :show, status: :ok, location: @variant }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @variant.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @check_destroy = @variant.destroy ? true : false
    respond_to do |format|
      if @check_destroy == true
        flash.now[:success] = t(".success")
      else
        flash.now[:notice] = @variant.errors.full_messages.join(" ")
      end
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.remove(dom_id(@product, dom_id(@variant))),
          render_turbo_flash
        ]
      end
      format.html { redirect_to variants_path, notice: "Variant was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_product
    @product = Product.find(params[:product_id])
  end
  
  def set_variant
    @variant = @product.variants.find(params[:id])
  end

  def variant_params
    params.require(:variant).permit(:product_id, :sku, :barcode, :quantity, :cost_price, :price)
  end

end
