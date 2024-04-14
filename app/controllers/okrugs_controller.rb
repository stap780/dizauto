class OkrugsController < ApplicationController
  load_and_authorize_resource
  before_action :set_okrug, only: %i[show edit update destroy]

  # GET /okrugs or /okrugs.json
  def index
    @search = Okrug.ransack(params[:q])
    @search.sorts = "position asc" if @search.sorts.empty?
    @okrugs = @search.result(distinct: true).paginate(page: params[:page], per_page: 100)
  end

  # GET /okrugs/1 or /okrugs/1.json
  def show
  end

  # GET /okrugs/new
  def new
    @okrug = Okrug.new
  end

  # GET /okrugs/1/edit
  def edit
  end

  # POST /okrugs or /okrugs.json
  def create
    @okrug = Okrug.new(okrug_params)

    respond_to do |format|
      if @okrug.save
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update(Okrug.new, ''),
            render_turbo_flash
          ]
        end
        format.html { redirect_to okrugs_url, notice: "Okrug was successfully created." }
        format.json { render :show, status: :created, location: @okrug }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @okrug.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /okrugs/1 or /okrugs/1.json
  def update
    respond_to do |format|
      if @okrug.update(okrug_params)
        flash.now[:success] = t(".success")
        format.turbo_stream do
          render turbo_stream: [
            render_turbo_flash
          ]
        end
        format.html { redirect_to okrugs_url, notice: "Okrug was successfully updated." }
        format.json { render :show, status: :ok, location: @okrug }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @okrug.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /okrugs/1 or /okrugs/1.json
  def destroy
    @okrug.destroy
    respond_to do |format|
      format.html { redirect_to okrugs_url, notice: "Okrug was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def sort
    @okrug.insert_at params[:new_position]
    head :ok
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_okrug
    @okrug = Okrug.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def okrug_params
    params.require(:okrug).permit(:title, :position)
  end
end
