class IncasesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_incase, only: %i[ show edit update destroy ]

  # GET /incases or /incases.json
  def index
    # @incases = Incase.all
    @search = Incase.ransack(params[:q])
    @search.sorts = 'id desc' if @search.sorts.empty?
    @incases = @search.result(distinct: true).paginate(page: params[:page], per_page: 100)
  end

  # GET /incases/1 or /incases/1.json
  def show
  end

  # GET /incases/new
  def new
    @incase = Incase.new
    #@line_items = @incase.line_items.build #@incase.line_items
  end

  # GET /incases/1/edit
  def edit
  end

  # POST /incases or /incases.json
  def create
    @incase = Incase.new(incase_params)
    respond_to do |format|
      if params[:commit].include?('Создать из импорта')
        @turbo_id = params[:commit].remove('Создать из импорта').to_s
        if @incase.save
          flash.now[:success] = "Incase was successfully created"
          format.turbo_stream
        else
          format.turbo_stream { render :import_incase_error, status: :unprocessable_entity }
        end
      else
        if @incase.save
          format.html { redirect_to incases_url, notice: "Incase was successfully created." }
          format.json { render :show, status: :created, location: @incase }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @incase.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def create_from_import

  end

  # PATCH/PUT /incases/1 or /incases/1.json
  def update
    respond_to do |format|
      if @incase.update(incase_params)
        format.html { redirect_to incases_url, notice: "Incase was successfully updated." }
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
      format.html { redirect_to incases_url, notice: "Incase was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def file_import #get
    #this work for modal as turbo_stream
  end

  def import_setup #post
    service = IncaseService::Import.new(params[:file])

    import_data = service.collect_data
    #puts 'incase_import_data => '+incase_import_data.to_s
    if import_data
      @header = import_data[:header]
      @file_data = import_data[:file_data]
      @our_fields = Incase.import_attributes
    else
      flash[:alert] = 'Ошибка в файле импорта'
    end
  end

  def convert_file_data
    puts "start convert_file_data"
    @data_group_by_unumber = IncaseService::Import.convert_file_data(params)
    @incase = Incase.new
    @virtual_incases = IncaseService::Import.collect_virtual_incases(@data_group_by_unumber)
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
      params.require(:incase).permit(:region, :strah_id, :stoanumber, :unumber, :company_id, :carnumber, :date, :modelauto, :totalsum, :status, :tip,
        :line_items_attributes =>[:id, :incase_id, :title, :quantity, :katnumber, :price, :sum, :status, :_destroy])
    end
end
