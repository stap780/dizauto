# IncasesController < ApplicationController
class IncasesController < ApplicationController
  load_and_authorize_resource
  before_action :set_incase, only: %i[show edit update destroy act]
  include SearchQueryRansack
  include DownloadExcel
  include NestedItem
  include BulkStatus

  def index
    @search = Incase.includes(:strah, :incase_items).ransack(search_params)
    @search.sorts = 'id desc' if @search.sorts.empty?
    @incases = @search.result(distinct: true).paginate(page: params[:page], per_page: 100)
    respond_to do |format|
      format.html
    end
  end

  def show; end

  def new
    @incase = Incase.new
    @incase.incase_items.build
    @incase.comments.build
  end

  def edit
    @commentable = @incase
  end

  def create
    @incase = Incase.new(incase_params)
    respond_to do |format|
      if @incase.save
        format.html { redirect_to incases_url, notice: t('.success') }
        format.json { render :show, status: :created, location: @incase }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @incase.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @incase.update(incase_params)
        format.html { redirect_to incases_url, notice: t('.success') }
        format.json { render :show, status: :ok, location: @incase }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @incase.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @incase.destroy

    respond_to do |format|
      format.html { redirect_to incases_url, notice: t('.success') }
      format.json { head :no_content }
      format.turbo_stream { flash.now[:success] = t('.success') }
    end
  end

  def act
    @company = @incase.company
    @strahcompany = @incase.strah

    respond_to do |format|
      format.pdf do
        render template: 'incases/act', pdf: "act_#{@incase.id}" # Excluding ".pdf" extension.
      end
    end
  end

  def bulk_print # post
    if params[:incase_ids]
      templ_id = params[:button].split('#').last
      BulkPrintJob.perform_later('Incase', params[:incase_ids], templ_id, current_user.id)
      render turbo_stream: 
        turbo_stream.update(
          'modal',
          template: 'shared/pending_bulk'
        )
    else
      notice = 'Выберите позиции'
      redirect_to incases_url, alert: notice
    end
  end

  def new_supply
    # respond_to do |format|
    #   format.turbo_stream
    # end
    if params[:incase_ids]
      @incases = Incase.where(id: params[:incase_ids])
      respond_to do |format|
        format.turbo_stream
      end
    else
      flash.now[:notice] = 'Выберите позиции'
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            render_turbo_flash
          ]
        end
      end
    end
  end

  private

  def set_incase
    @incase = Incase.find(params[:id])
  end

  def incase_params
    params.require(:incase).permit(
      :region,
      :strah_id,
      :stoanumber,
      :unumber,
      :company_id,
      :carnumber,
      :date,
      :modelauto,
      :totalsum,
      :incase_status_id,
      :incase_tip_id,
      incase_items_attributes: %i[id variant_id title quantity katnumber price sum incase_item_status_id _destroy]
      )
  end
end
