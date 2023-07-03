class ExportsController < ApplicationController
  load_and_authorize_resource
  before_action :set_export, only: %i[ show edit update destroy ]

  # GET /exports or /exports.json
  def index
    # @exports = Export.all
    @search = Export.ransack(params[:q])
    @search.sorts = 'id desc' if @search.sorts.empty?
    @exports = @search.result(distinct: true).paginate(page: params[:page], per_page: 100)
  end

  # GET /exports/1 or /exports/1.json
  def show
  end

  # GET /exports/new
  def new
    @export = Export.new
  end

  # GET /exports/1/edit
  def edit
  end

  # POST /exports or /exports.json
  def create
    @export = Export.new(export_params)

    respond_to do |format|
      if @export.save
        Rails.env.development? ? ExportCreator.call(@export) : ExportJob.perform_later(@export)

        format.html { redirect_to exports_url, notice: "Экспорт создан" }
        format.json { render :show, status: :created, location: @export }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @export.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /exports/1 or /exports/1.json
  def update
    respond_to do |format|
      if @export.update(export_params)
        Rails.env.development? ? ExportCreator.call(@export) : ExportJob.perform_later(@export)

        format.html { redirect_to exports_url, notice: "Экспорт обновлён." }
        format.json { render :show, status: :ok, location: @export }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @export.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /exports/1 or /exports/1.json
  def destroy
    @export.destroy

    respond_to do |format|
      format.html { redirect_to exports_url, notice: "Export was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_export
      @export = Export.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def export_params
      params.require(:export).permit(:title, :link, :template, :time, :format,:use_property, excel_attributes: [])
    end
end
