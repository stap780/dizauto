class DetalsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_detal, only: %i[ show edit update destroy ]

  # GET /detals or /detals.json
  def index
    # @detals = Detal.all
    @search = Detal.ransack(params[:q])
    @search.sorts = 'id desc' if @search.sorts.empty?
    @detals = @search.result(distinct: true).paginate(page: params[:page], per_page: 100)
  end

  # GET /detals/1 or /detals/1.json
  def show
  end

  # GET /detals/new
  def new
    @detal = Detal.new
    @props = @detal.props
  end

  # GET /detals/1/edit
  def edit
    @props = @detal.props
  end

  # POST /detals or /detals.json
  def create
    @detal = Detal.new(detal_params)

    respond_to do |format|
      if @detal.save
        format.html { redirect_to detals_path, notice: "Detal was successfully created." }
        format.json { render :show, status: :created, location: @detal }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @detal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /detals/1 or /detals/1.json
  def update
    respond_to do |format|
      if @detal.update(detal_params)
        format.html { redirect_to detals_path, notice: "Detal was successfully updated." }
        format.json { render :show, status: :ok, location: @detal }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @detal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /detals/1 or /detals/1.json
  def destroy
    @detal.destroy

    respond_to do |format|
      format.html { redirect_to detals_url, notice: "Detal was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_detal
      @detal = Detal.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def detal_params
      params.require(:detal).permit(:sku, :title, :description, prop_attributes: [:id,:product_id,:property_id,:characteristic_id, :detal_id, :_destroy])
    end
end
