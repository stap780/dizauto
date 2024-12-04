class IncaseImportsController < ApplicationController
  load_and_authorize_resource
  before_action :set_incase_import, only: %i[show edit update import_start check_import destroy]
  before_action :validate_params, only: [:update]
  include SearchQueryRansack
  include DownloadExcel

  def index
    @search = IncaseImport.ransack(search_params)
    @search.sorts = "id desc" if @search.sorts.empty?
    @incase_imports = @search.result(distinct: true).paginate(page: params[:page], per_page: 100)
    respond_to do |format|
      format.html
    end
  end

  def show
  end

  def new
    @incase_import = IncaseImport.new
  end

  def edit
    if @incase_import.incase_import_columns.size < 1
      service = Incase::Import.new(@incase_import)
      header_data = service.header
      if header_data
        data = header_data.map { |d| {column_file: d, column_system: nil} }
        @incase_import.incase_import_columns.create!(data)
      else
        flash[:alert] = 'Import file not valid'
      end
    end
  end

  def create
    @incase_import = IncaseImport.new(incase_import_params)

    respond_to do |format|
      if @incase_import.save
        flash.now[:success] = t(".success")
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update(IncaseImport.new, ''),
            render_turbo_flash
          ]
        end
        format.html { redirect_to edit_incase_import_url(@incase_import), notice: 'File uploaded' }
        format.json { render :show, status: :created, location: @incase_import }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @incase_import.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    success, message = validate_params
    if success
      respond_to do |format|
        if @incase_import.update(incase_import_params)
          format.html { redirect_to incase_import_url(@incase_import), notice: 'Настройки импорта сохранены' }
          format.json { render :show, status: :ok, location: @incase_import }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @incase_import.errors, status: :unprocessable_entity }
        end
      end
    else
      flash.now[:notice] = message
      render :edit, status: :unprocessable_entity
    end
  end

  def check
    IncaseImportCheckFileJob.perform_later(@incase_import, current_user.id)
    respond_to do |format|
      format.turbo_stream
    end
  end

  def start # get
    IncaseImportStartImportJob.perform_later(@incase_import, current_user.id)
    respond_to do |format|
      format.turbo_stream
    end
  end

  def destroy
    @incase_import.destroy

    respond_to do |format|
      format.html { redirect_to incase_imports_url, notice: 'Incase import was successfully destroyed.' }
      format.json { head :no_content }
      format.turbo_stream { flash.now[:success] = t('.success') }
    end
  end

  private

  def set_incase_import
    @incase_import = IncaseImport.find(params[:id])
  end

  def incase_import_params
    params.require(:incase_import).permit(:check, :active, :title, :report, :file, :uniq_field, :file, 
      incase_import_columns_attributes: [:id, :incase_import_id, :column_file, :column_system, :_destroy])
  end

  def validate_params
    status = []
    message = []
    uniq_field = params[:incase_import][:uniq_field]

    # puts "strategy: product // "
    # message.push('strategy: product //')
    system = params[:incase_import][:incase_import_columns_attributes].values.map { |c| c['column_system'] }.reject(&:blank?)
    puts "system => #{system.inspect}"
    status.push(system.include?(uniq_field) ? true : false)
    message.push(system.include?(uniq_field) ? '' : 'Need set uniq_field column')
    # status.push( system.include?('product#name') ? true : false )
    # message.push( system.include?('product#name') ? '' : 'Need product name' )
    # status.push( system.include?('product#price') ? true : false )
    # message.push( system.include?('product#price') ? '' : 'Need set price' )

    check_status = status.uniq.to_s == '[true]'
    [check_status, message.join(' ')]
  end
end
