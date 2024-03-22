class ExportsController < ApplicationController
  load_and_authorize_resource
  before_action :set_export, only: %i[show edit update destroy run download]

  # GET /exports or /exports.json
  def index
    # @exports = Export.all
    @search = Export.ransack(params[:q])
    @search.sorts = "id desc" if @search.sorts.empty?
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
        format.html { redirect_to exports_url, notice: "Экспорт обновлён." }
        format.json { render :show, status: :ok, location: @export }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @export.errors, status: :unprocessable_entity }
      end
    end
  end

  def run
    ExportJob.perform_later(@export, current_user.id)
    respond_to do |format|
      format.turbo_stream
    end
    # Rails.env.development? ? ExportCreator.call(@export) : ExportJob.perform_later(@export)
  end

  # DELETE /exports/1 or /exports/1.json
  def destroy
    @export.destroy

    respond_to do |format|
      format.html { redirect_to exports_url, notice: "Export was successfully destroyed." }
      format.json { head :no_content }
      format.turbo_stream { flash.now[:success] = t(".success") }
    end
  end

  def download
    if @export.link.present?
      respond_to do |format|
        format.html do
          filename = @export.link.split("/").last
          zipfile_name = "#{filename.tr(".", "_")}_#{Time.zone.now.strftime("%d_%m_%Y_%I_%M")}.zip"
          # zipfile = "#{Rails.public_path}/#{filename.gsub('.','_')}_#{Time.zone.now.strftime("%d_%m_%Y_%I_%M")}.zip"
          temp_file = Tempfile.new(zipfile_name)
          Zip::File.open(temp_file.path, create: true) do |zip|
            zip.add(filename, File.join(Rails.public_path, filename))
          end
          # send_file(zipfile, disposition: 'attachment', type: 'application/zip')
          zip_data = File.read(temp_file.path)
          send_data(zip_data, type: "application/zip", filename: zipfile_name)
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to exports_url, notice: "Export don't have link" }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_export
    @export = Export.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def export_params
    params.require(:export).permit(:title, :link, :template, :time, :format, :use_property, :test, excel_attributes: [])
  end
end
