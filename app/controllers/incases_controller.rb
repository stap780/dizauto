class IncasesController < ApplicationController
  load_and_authorize_resource
  before_action :set_incase, only: %i[ show edit update destroy act print ]

  # GET /incases or /incases.json
  def index
    @search = Incase.includes(:strah, :incase_items).ransack(params[:q])
    @search.sorts = 'id desc' if @search.sorts.empty?
    @incases = @search.result(distinct: true).paginate(page: params[:page], per_page: 100)
    filename = 'incases.xlsx'
    collection = @search.present? ? @search.result(distinct: true) : @incases
    respond_to do |format|
      format.html
      format.zip do
        service = CreateXlsx.new(collection, {filename: filename, template: "incases/index"} )
        compressed_filestream = service.call
        send_data compressed_filestream.read, filename: 'incases.zip', type: 'application/zip'
      end
    end
  end

  # GET /incases/1 or /incases/1.json
  def show
  end

  # GET /incases/new
  def new
    @incase = Incase.new
  end

  # GET /incases/1/edit
  def edit
  end

  # POST /incases or /incases.json
  def create
    @incase = Incase.new(incase_params)
    respond_to do |format|
      if @incase.save
        @incase.automation_on_create
        format.html { redirect_to incases_url, notice: t('.success') }
        format.json { render :show, status: :created, location: @incase }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @incase.errors, status: :unprocessable_entity }
      end
    end
  end

  def create_from_import
    @incase = Incase.new(incase_params)
    respond_to do |format|
      @turbo_id = params[:commit].remove('Создать из импорта').to_s
      if @incase.save
        @incase.automation_on_create
        flash.now[:success] = t('.success')
        format.turbo_stream { render 'incases/import/create_from_import' }
      else
        format.turbo_stream { render 'incases/import/import_incase_error', status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /incases/1 or /incases/1.json
  def update
    respond_to do |format|
      if @incase.update(incase_params)
        @incase.automation_on_update
        format.html { redirect_to incases_url, notice: t('.success') }
        format.json { render :show, status: :ok, location: @incase }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @incase.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /incases/1 or /incases/1.json
  def destroy
    @incase.destroy

    respond_to do |format|
      format.html { redirect_to incases_url, notice: t('.success') }
      format.json { head :no_content }
    end
  end

  def file_import #get
    #this work for modal as turbo_stream
    render 'incases/import/file_import'
  end

  def import_setup #post
    service = IncaseService::Import.new(params[:file])

    import_data = service.collect_data
    #puts 'incase_import_data => '+incase_import_data.to_s
    if import_data
      @header = import_data[:header]
      @file_data = import_data[:file_data]
      @our_fields = Incase.import_attributes
      render 'incases/import/import_setup'
    else
      flash[:alert] = 'Ошибка в файле импорта'
    end
  end

  def convert_file_data
    puts "start convert_file_data"
    @data_group_by_unumber = IncaseService::Import.convert_file_data(params)
    @virtual_incases = IncaseService::Import.collect_virtual_incases(@data_group_by_unumber)
    render 'incases/import/convert_file_data'
  end

  def act
    @company = @incase.company
		@strahcompany = @incase.strah

    respond_to do |format|
      format.pdf do
        render template: 'incases/act', pdf: "act_"+@incase.id.to_s   # Excluding ".pdf" extension.
      end
    end
  end

  def print
    templ = Templ.find(params[:templ_id])
    success, pdf = CreatePdf.new(@incase, {templ: templ}).call
    if success
      send_file pdf, type: 'application/pdf', disposition: 'attachment'
    else
      alert = 'Ошибка в файле печати: '+pdf.to_s
      redirect_to incases_url, notice: alert
    end
  end

  def bulk_print #post
    if params[:incase_ids]
      templ_id = params[:button].split('#').last
      BulkPrintJob.perform_later('Incase', params[:incase_ids], templ_id)
    else
      alert = 'Выберите позиции'
      redirect_to incases_url, notice: alert
    end
  end

  def pending_bulk #get
    render "shared/pending_bulk"
  end

  def success_bulk #get
    render "shared/success_bulk"
  end


  # def update_from_file #put
  #   Rails.env.development? ? IncaseService::Import.update(params) : IncaseImportJob.perform_later(params.to_unsafe_hash)
  #   redirect_to incases_url, notice: 'Запущен процесс создания импорта. Дождитесь выполнении процесса. Поступит уведомление на почту'
  # end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_incase
      @incase = Incase.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def incase_params
      params.require(:incase).permit(:region, :strah_id, :stoanumber, :unumber, :company_id, :carnumber, :date, :modelauto, :totalsum, :incase_status_id, :incase_tip_id,
        incase_items_attributes: [:id, :incase_id, :title, :quantity, :katnumber, :price, :sum, :incase_item_status_id, :_destroy])
    end
end
