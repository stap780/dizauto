class InvoiceStatusesController < ApplicationController
  load_and_authorize_resource
  before_action :set_invoice_status, only: %i[ show edit update sort destroy ]

  # GET /invoice_statuses or /invoice_statuses.json
  def index
    @search = InvoiceStatus.ransack(params[:q])
    @search.sorts = "position asc" if @search.sorts.empty?
    @invoice_statuses = @search.result(distinct: true).paginate(page: params[:page], per_page: 100)
  end

  # GET /invoice_statuses/1 or /invoice_statuses/1.json
  def show
  end

  # GET /invoice_statuses/new
  def new
    @invoice_status = InvoiceStatus.new
  end

  # GET /invoice_statuses/1/edit
  def edit
  end

  # POST /invoice_statuses or /invoice_statuses.json
  def create
    @invoice_status = InvoiceStatus.new(invoice_status_params)

    respond_to do |format|
      if @invoice_status.save
        flash.now[:success] = t(".success")
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update(InvoiceStatus.new, ''),
            render_turbo_flash
          ]
        end
        format.html { redirect_to invoice_status_url(@invoice_status), notice: "Invoice status was successfully created." }
        format.json { render :show, status: :created, location: @invoice_status }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @invoice_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /invoice_statuses/1 or /invoice_statuses/1.json
  def update
    respond_to do |format|
      if @invoice_status.update(invoice_status_params)
        flash.now[:success] = t(".success")
        format.turbo_stream do
          render turbo_stream: [
            render_turbo_flash
          ]
        end
        format.html { redirect_to invoice_status_url(@invoice_status), notice: "Invoice status was successfully updated." }
        format.json { render :show, status: :ok, location: @invoice_status }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @invoice_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /invoice_statuses/1 or /invoice_statuses/1.json
  def destroy
    # @invoice_status.destroy!
    @check_destroy = @invoice_status.destroy ? true : false
    message = if @check_destroy == true
                flash.now[:success] = t(".success")
              else
                flash.now[:notice] = @invoice_status.errors.full_messages.join(" ")
              end
    respond_to do |format|
      format.html { redirect_to invoice_statuses_url, notice: "Invoice status was successfully destroyed." }
      format.json { head :no_content }
      format.turbo_stream { message }
    end
  end

  def sort
    @invoice_status.insert_at params[:new_position]
    head :ok
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_invoice_status
      @invoice_status = InvoiceStatus.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def invoice_status_params
      params.require(:invoice_status).permit(:title, :color, :position)
    end
end
