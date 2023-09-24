class ClientsController < ApplicationController
  load_and_authorize_resource
  before_action :set_client, only: %i[ show edit update destroy ]

  # GET /clients or /clients.json
  def index
    @search = Client.ransack(params[:q])
    @search.sorts = 'id desc' if @search.sorts.empty?
    @clients = @search.result(distinct: true).paginate(page: params[:page], per_page: 100)
    filename = 'clients.xlsx'
    collection = @search.present? ? @search.result(distinct: true) : @clients
    respond_to do |format|
      format.html
      format.zip do
        service = CreateXlsx.new(collection, {filename: filename, template: "clients/index"} )
        compressed_filestream = service.call
        send_data compressed_filestream.read, filename: 'clients.zip', type: 'application/zip'
      end
    end
  end

  # GET /clients/1 or /clients/1.json
  def show
  end

  # GET /clients/new
  def new
    @client = Client.new
  end
  
  def new_turbo
    @client = Client.new
    @company_id = params[:company_id]
  end

  # GET /clients/1/edit
  def edit
  end

  # POST /clients or /clients.json
  def create
    @client = Client.new(client_params)

    respond_to do |format|
      if @client.save
        format.turbo_stream
        format.html { redirect_to clients_url, notice: t('.success') }
        format.json { render :show, status: :created, location: @client }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  def create_turbo
    @client = Client.new(client_params)
    @company = params[:company_id].present? ? Company.find(params[:company_id]) : Company.new
    respond_to do |format|
      if @client.save
        format.turbo_stream {flash.now[:notice] = t('.success')}
        format.html { redirect_to clients_url, notice: t('.success') }
        format.json { render :show, status: :created, location: @client }
      else
        format.html { render :new_turbo, status: :unprocessable_entity }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /clients/1 or /clients/1.json
  def update
    respond_to do |format|
      if @client.update(client_params)
        format.html { redirect_to clients_url, notice: t('.success') }
        format.json { render :show, status: :ok, location: @client }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clients/1 or /clients/1.json
  def destroy
    @client.destroy

    respond_to do |format|
      format.html { redirect_to clients_url, notice: t('.success') }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_client
      @client = Client.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def client_params
      params.require(:client).permit(:surname, :name, :middlename, :phone, :email)
    end
end
