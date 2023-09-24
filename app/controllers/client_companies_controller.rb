class ClientCompaniesController < ApplicationController
  load_and_authorize_resource
  before_action :set_client_company, only: %i[ show edit update destroy ]

  # GET /client_companies or /client_companies.json
  def index
    @client_companies = ClientCompany.all
  end

  # GET /client_companies/1 or /client_companies/1.json
  def show
  end

  # GET /client_companies/new
  def new
    @client_company = ClientCompany.new
  end

  def new_turbo
    @client_company = ClientCompany.new
    render layout: false
  end

  # GET /client_companies/1/edit
  def edit
  end

  # POST /client_companies or /client_companies.json
  def create
    @client_company = ClientCompany.new(client_company_params)

    respond_to do |format|
      if @client_company.save
        format.turbo_stream { flash.now[:success] = t('.success') }
        format.html { redirect_to client_company_url(@client_company), notice: "Client company was successfully created." }
        format.json { render :show, status: :created, location: @client_company }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @client_company.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /client_companies/1 or /client_companies/1.json
  def update
    respond_to do |format|
      if @client_company.update(client_company_params)
        format.html { redirect_to client_company_url(@client_company), notice: "Client company was successfully updated." }
        format.json { render :show, status: :ok, location: @client_company }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @client_company.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /client_companies/1 or /client_companies/1.json
  def destroy
    @client_company.destroy

    respond_to do |format|
      format.html { redirect_to client_companies_url, notice: "Client company was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_client_company
      @client_company = ClientCompany.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def client_company_params
      params.require(:client_company).permit(:client_id, :company_id)
    end
end
