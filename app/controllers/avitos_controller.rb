class AvitosController < ApplicationController
  before_action :authenticate_user!, except: %i[order]
  before_action :set_avito, only: %i[show edit update destroy check]

  def index
    @search = Avito.ransack(params[:q])
    @search.sorts = 'id asc' if @search.sorts.empty?
    @avitos = @search.result(distinct: true).paginate(page: params[:page], per_page: 100)
  end

  def show; end

  def new
    @avito = Avito.new
  end

  def edit; end

  def create
    @avito = Avito.new(avito_params)

    respond_to do |format|
      if @avito.save
        flash.now[:success] = t('.success')
        format.turbo_stream do
          render turbo_stream: [
            render_turbo_flash
          ]
        end
        format.html { redirect_to @avito, notice: 'Avito was successfully created.' }
        format.json { render :show, status: :created, location: @avito }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @avito.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @avito.update(avito_params)
        flash.now[:success] = t('.success')
        format.turbo_stream do
          render turbo_stream: [
            render_turbo_flash
          ]
        end
        format.html { redirect_to @avito, notice: 'Avito was successfully updated.' }
        format.json { render :show, status: :ok, location: @avito }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @avito.errors, status: :unprocessable_entity }
      end
    end
  end

  def check
    result = @avito.api_work?
    if result
      respond_to do |format|
        flash.now[:success] = "#{t('.success')} API work"
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

  def destroy
    @avito.destroy!

    respond_to do |format|
      flash.now[:success] = t('.success')
      format.turbo_stream do
        render turbo_stream: [
          render_turbo_flash
        ]
      end
      format.html { redirect_to avitos_path, status: :see_other, notice: 'Avito was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_avito
    @avito = Avito.find(params[:id])
  end

  def avito_params
    params.require(:avito).permit(:title, :api_id, :api_secret, :profileid)
  end
end
