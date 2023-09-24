class IncaseTipsController < ApplicationController
  load_and_authorize_resource
  before_action :set_incase_tip, only: %i[ show edit update destroy ]

  # GET /incase_tips or /incase_tips.json
  def index
    @search = IncaseTip.ransack(params[:q])
    @search.sorts = 'id desc' if @search.sorts.empty?
    @incase_tips = @search.result(distinct: true).paginate(page: params[:page], per_page: 100)
  end

  # GET /incase_tips/1 or /incase_tips/1.json
  def show
  end

  # GET /incase_tips/new
  def new
    @incase_tip = IncaseTip.new
  end

  # GET /incase_tips/1/edit
  def edit
  end

  # POST /incase_tips or /incase_tips.json
  def create
    @incase_tip = IncaseTip.new(incase_tip_params)

    respond_to do |format|
      if @incase_tip.save
        format.turbo_stream { flash.now[:success] = t('.success') }
        format.html { redirect_to incase_tips_url, notice: t('.success') }
        format.json { render :show, status: :created, location: @incase_tip }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @incase_tip.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /incase_tips/1 or /incase_tips/1.json
  def update
    respond_to do |format|
      if @incase_tip.update(incase_tip_params)
        format.turbo_stream { flash.now[:success] = t('.success') }
        format.html { redirect_to incase_tips_url, notice: "Incase tip was successfully updated." }
        format.json { render :show, status: :ok, location: @incase_tip }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @incase_tip.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /incase_tips/1 or /incase_tips/1.json
  def destroy
    @incase_tip.destroy

    respond_to do |format|
      format.html { redirect_to incase_tips_url, notice: "Incase tip was successfully destroyed." }
      format.json { head :no_content }
      format.turbo_stream { flash.now[:success] = t('.success') }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_incase_tip
      @incase_tip = IncaseTip.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def incase_tip_params
      params.require(:incase_tip).permit(:title, :color)
    end
end
