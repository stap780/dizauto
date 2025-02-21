class CompaniesController < ApplicationController
  load_and_authorize_resource
  before_action :set_company, only: %i[show edit update destroy]

  def index
    @search = Company.ransack(params[:q])
    @search.sorts = 'id desc' if @search.sorts.empty?
    @companies = @search.result(distinct: true).paginate(page: params[:page], per_page: 100)
  end

  def download
    filename = 'companies.xlsx'
    collection_ids = params[:company_ids].present? ? params[:company_ids] : Company.all.pluck(:id)
    CreateZipXlsxJob.perform_later(collection_ids, {  model: 'Company',
                                                      current_user_id: current_user.id,
                                                      filename: filename,
                                                      template: 'companies/index'})
    render turbo_stream: 
      turbo_stream.update(
        'modal',
        template: 'shared/pending_bulk'
      )
  end

  def show
  end

  def new
    @company = Company.new
  end

  def edit; end

  def create
    @company = Company.new(company_params)

    respond_to do |format|
      if @company.save
        format.html { redirect_to companies_url, notice: t(".success") }
        format.json { render :show, status: :created, location: @company }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @company.update(company_params)
        format.html { redirect_to companies_url, notice: t(".success") }
        format.json { render :show, status: :ok, location: @company }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @check_destroy = @company.destroy ? true : false
    message = if @check_destroy == true
                flash.now[:success] = t(".success")
              else
                flash.now[:notice] = @company.errors.full_messages.join(" ")
              end
    respond_to do |format|
      format.html { redirect_to companies_url, notice: t(".success") }
      format.json { head :no_content }
      format.turbo_stream { flash.now[:success] = t(".success") }
    end
  end

  private

  def set_company
    @company = Company.find(params[:id])
  end

  def company_params
    params.require(:company).permit(:okrug_id, :tip, :inn, :kpp, :title, :short_title, :ur_address, :fact_address, :ogrn, :okpo, :bik, :bank_title, :bank_account, :info,
      client_companies_attributes: [:id, :client_id, :company_id, :_destroy], company_plan_dates_attributes: [:id, :date, :_destroy, comments_attributes: [:id, :commentable_type, :commentable_id, :user_id, :body, :_destroy]])
  end
end

# , comments_attributes: [:id, :commentable_type, :commentable_id, :user_id, :body, :_destroy]
