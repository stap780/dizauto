# MitupaisController < ApplicationController
class MitupaisController < ApplicationController
  load_and_authorize_resource
  before_action :set_mitupai, only: %i[ show edit update destroy ]

  def index
    @mitupais = Mitupai.all
  end

  def show; end

  def new
    if Mitupai.exists?
      respond_to do |format|
        flash.now[:notice] = 'You already have integration.'
        format.turbo_stream do
          render turbo_stream: [
            render_turbo_flash
          ]
        end
        format.html { redirect_to mitupais_path, notice: 'You already have integration.' }
      end
    else
      @mitupai = Mitupai.new
    end
  end

  def edit; end

  def create
    @mitupai = Mitupai.new(mitupai_params)

    respond_to do |format|
      if @mitupai.save
        format.html { redirect_to @mitupai, notice: 'Mitupai was successfully created.' }
        format.json { render :show, status: :created, location: @mitupai }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @mitupai.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /mitupais/1 or /mitupais/1.json
  def update
    respond_to do |format|
      if @mitupai.update(mitupai_params)
        format.html { redirect_to @mitupai, notice: 'Mitupai was successfully updated.' }
        format.json { render :show, status: :ok, location: @mitupai }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @mitupai.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /mitupais/1 or /mitupais/1.json
  def destroy
    @mitupai.destroy!

    respond_to do |format|
      format.html { redirect_to mitupais_path, status: :see_other, notice: 'Mitupai was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mitupai
      @mitupai = Mitupai.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def mitupai_params
      params.require(:mitupai).permit(:api_url, :api_key)
    end
end
