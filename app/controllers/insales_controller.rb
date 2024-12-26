# InsalesController
class InsalesController < ApplicationController
  before_action :authenticate_user!, except: %i[order]
  before_action :set_insale, only: %i[ show edit update destroy ]

  def index
    @search = Insale.ransack(params[:q])
    @search.sorts = 'id asc' if @search.sorts.empty?
    @insales = @search.result(distinct: true).paginate(page: params[:page], per_page: 100)
  end

  def show; end

  def new
    if Insale.count.zero?
      @insale = Insale.new
    else
      respond_to do |format|
        flash.now[:success] = 'у вас уже есть интеграция'
        format.turbo_stream do
          render turbo_stream: [
            render_turbo_flash
          ]
        end
        format.html { redirect_to insales_path, notice: 'у вас уже есть интеграция' }
      end
    end
  end

  def edit; end

  def create
    @insale = Insale.new(insale_params)

    respond_to do |format|
      if @insale.save
        flash.now[:success] = t('.success')
        format.turbo_stream do
          render turbo_stream: [
            render_turbo_flash
          ]
        end
        format.html { redirect_to insale_url(@insale), notice: t('.success') }
        format.json { render :show, status: :created, location: @insale }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @insale.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @insale.update(insale_params)
        flash.now[:success] = t('.success')
        format.turbo_stream do
          render turbo_stream: [
            render_turbo_flash
          ]
        end
        format.html { redirect_to insale_url(@insale), notice: t('.success') }
        format.json { render :show, status: :ok, location: @insale }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @insale.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @insale.destroy!

    respond_to do |format|
      flash.now[:success] = t('.success')
      format.turbo_stream do
        render turbo_stream: [
          render_turbo_flash
        ]
      end
      format.html { redirect_to insales_path, notice: t('.success') }
      format.json { head :no_content }
    end
  end

  def check
    result, message = Insale.api_work?
    if result
      respond_to do |format|
        flash.now[:success] = "#{t(".success")} API work"
        format.turbo_stream do
          render turbo_stream: [
            render_turbo_flash
          ]
        end
      end
    else
      respond_to do |format|
        flash.now[:error] = message
        format.turbo_stream do
          render turbo_stream: [
            render_turbo_flash
          ]
        end
      end
    end
  end

  def order
    InsaleOrderImportJob.perform_later(params.permit!)
    head :ok
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_insale
      @insale = Insale.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def insale_params
      params.require(:insale).permit(:api_key, :api_password, :api_link)
    end
end
