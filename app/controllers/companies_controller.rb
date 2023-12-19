class CompaniesController < ApplicationController
  load_and_authorize_resource
  before_action :set_company, only: %i[ show edit update destroy ]

  # GET /companies or /companies.json
  def index
    # @companies = Company.all
    @search = Company.ransack(params[:q])
    @search.sorts = 'id desc' if @search.sorts.empty?
    @companies = @search.result(distinct: true).paginate(page: params[:page], per_page: 100)
  end

  # GET /companies/1 or /companies/1.json
  def show
  end

  # GET /companies/new
  def new
    @company = Company.new
    # @comment = Comment.new
    @company.client_companies.build
    @company.company_plan_dates.build
  end
  
  # GET /companies/1/edit
  def edit
    # @comment = @company.comments.present? ? @company.comments.first : Comment.new
  end

  # POST /companies or /companies.json
  def create
    @company = Company.new(company_params)

    respond_to do |format|
      if @company.save
        format.html { redirect_to companies_url, notice: t('.success') }
        format.json { render :show, status: :created, location: @company }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /companies/1 or /companies/1.json
  def update
    respond_to do |format|
      if @company.update(company_params)
        format.html { redirect_to companies_url, notice: t('.success')  }
        format.json { render :show, status: :ok, location: @company }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /companies/1 or /companies/1.json
  def destroy
    @company.destroy

    respond_to do |format|
      format.html { redirect_to companies_url, notice: t('.success') }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_company
      @company = Company.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def company_params
      params.require(:company).permit(:okrug_id, :tip,:inn, :kpp, :title, :short_title, :ur_address, :fact_address, :ogrn, :okpo, :bik, :bank_title, :bank_account, :info,
      client_companies_attributes: [:id, :client_id, :company_id, :_destroy], company_plan_dates_attributes: [:id, :date, :_destroy, comments_attributes: [:id, :commentable_type, :commentable_id, :user_id, :body, :_destroy]])
   
    end
end


#, comments_attributes: [:id, :commentable_type, :commentable_id, :user_id, :body, :_destroy]