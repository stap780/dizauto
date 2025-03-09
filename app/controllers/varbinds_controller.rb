# VarbindsController
class VarbindsController < ApplicationController
  load_and_authorize_resource
  before_action :set_product
  before_action :set_variant
  before_action :set_varbind, only: %i[ show edit update destroy ]
  include ActionView::RecordIdentifier

  def index
    @varbinds = Varbind.all
  end

  def show; end

  def new
    @varbind = @variant.varbinds.build
  end

  def edit
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update( 
            dom_id(@product, dom_id(@variant, dom_id(@varbind))),
            partial: 'varbinds/form',
            locals: {
              product: @product,
              variant: @variant,
              varbind: @varbind
            }
          )
        ]
      end
    end
  end

  def create
    @varbind = @variant.varbinds.build(varbind_params)

    respond_to do |format|
      if @varbind.save
        flash.now[:success] = t('.success')
        format.turbo_stream do
          render turbo_stream: [
            render_turbo_flash
          ]
        end
        format.html { redirect_to @varbind, notice: t('.success') }
        format.json { render :show, status: :created, location: @varbind }
      else
        format.turbo_stream do
          flash.now[:success] = @varbind.errors.full_messages.join(', ')
          render turbo_stream: [
            # turbo_stream.update( 
            #   dom_id(@product, dom_id(@variant, dom_id(Varbind.new))),
            #   partial: 'varbinds/form',
            #   locals: {
            #     product: @product,
            #     variant: @variant,
            #     varbind: Varbind.new
            #   }
            # )
            render_turbo_flash
          ]
        end
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @varbind.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @varbind.update(varbind_params)
        flash.now[:success] = t('.success')
        format.turbo_stream do
          render turbo_stream: [
            render_turbo_flash
          ]
        end
        format.html { redirect_to @varbind, notice: t('.success') }
        format.json { render :show, status: :ok, location: @varbind }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @varbind.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @varbind.destroy!

    respond_to do |format|
      flash.now[:success] = t('.success')
      format.turbo_stream do
        render turbo_stream: [
          render_turbo_flash
        ]
      end
      format.html { redirect_to varbinds_path, status: :see_other, notice: t('.success') }
      format.json { head :no_content }
    end
  end

  private

  def set_product
    @product = Product.find(params[:product_id])
  end

  def set_variant
    @variant = @product.variants.find(params[:variant_id])
  end

  def set_varbind
    @varbind = Varbind.find(params[:id])
  end

  def varbind_params
    params.require(:varbind).permit(:value, :variant_id, :varbindable_type, :varbindable_id)
  end

end
