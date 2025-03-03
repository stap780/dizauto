class ClientsController < ApplicationController
  load_and_authorize_resource
  before_action :set_client, only: %i[show edit update destroy]
  include SearchQueryRansack
  include DownloadExcel
  include BulkDelete
  include ActionView::RecordIdentifier
  
  def index
    @search = Client.ransack(params[:q])
    @search.sorts = 'id desc' if @search.sorts.empty?
    @clients = @search.result(distinct: true).paginate(page: params[:page], per_page: 100)
    # filename = "clients.xlsx"
    collection = @search.present? ? @search.result(distinct: true) : @clients
    respond_to do |format|
      format.html
    end
  end

  def show
  end

  def new
    @client = Client.new
  end

  def search
    if params[:title].present?
      @search_results = Client.all.where("name ILIKE ?", "%#{params[:title]}%").map { |p| {title: p.full_name, id: p.id} }.reject(&:blank?)
      render json: @search_results, status: :ok
    else
      render json: @search_results, status: :unprocessable_entity
    end
  end

  # def new_turbo
  #   @client = Client.new
  #   @company_id = params[:company_id]
  # end

  def edit
  end

  def create
    @client = Client.new(client_params)

    respond_to do |format|
      if @client.save
        flash.now[:success] = t('.success')
        format.turbo_stream do
          render turbo_stream: [
            render_turbo_flash
          ]
        end
        format.html { redirect_to clients_url, notice: t('.success') }
        format.json { render :show, status: :created, location: @client }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  # def create_turbo
  #   @client = Client.new(client_params)
  #   @company = params[:company_id].present? ? Company.find(params[:company_id]) : Company.new
  #   respond_to do |format|
  #     if @client.save
  #       format.turbo_stream { flash.now[:notice] = t(".success") }
  #       format.html { redirect_to clients_url, notice: t(".success") }
  #       format.json { render :show, status: :created, location: @client }
  #     else
  #       format.html { render :new_turbo, status: :unprocessable_entity }
  #       format.json { render json: @client.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  def update
    respond_to do |format|
      if @client.update(client_params)
        flash.now[:success] = t('.success')
        format.turbo_stream do
          render turbo_stream: [
            render_turbo_flash
          ]
        end
        format.html { redirect_to clients_url, notice: t('.success') }
        format.json { render :show, status: :ok, location: @client }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @check_destroy = @client.destroy ? true : false
    message = if @check_destroy == true
      flash.now[:success] = t('.success')
    else
      flash.now[:notice] = @client.errors.full_messages.join(' ')
    end

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          render_turbo_flash
        ]
      end
      format.html { redirect_to clients_url, notice: t('.success') }
      format.json { head :no_content }
    end
  end

  private

  def set_client
    @client = Client.find(params[:id])
  end

  def client_params
    params.require(:client).permit(:surname, :name, :middlename, :phone, :email, :insid)
  end
end