class ReturnsController < ApplicationController
  load_and_authorize_resource
  before_action :set_return, only: %i[ show edit update destroy ]
  include SearchQueryRansack
  include DownloadExcel
  include NestedItem

  def index
    @search = Return.ransack(search_params)
    @search.sorts = "id desc" if @search.sorts.empty?
    @returns = @search.result(distinct: true).paginate(page: params[:page], per_page: 100)
    respond_to do |format|
      format.html
    end
  end

  def show
  end

  def new
    if params[:invoice_id].present?
      invoice = Invoice.find(params[:invoice_id])
      @return = Return.new(company_id: invoice.company_id, client_id: invoice.client_id)
      items = invoice.invoice_items
      items.each do |inc|
        @return.return_items.build(variant_id: inc.variant.id, quantity: inc.quantity, price: inc.price, sum: (inc.quantity*inc.price))
      end
    else
      @return = Return.new
      @return.return_items.build
    end
  end

  def edit
  end

  def create
    @return = Return.new(return_params)

    respond_to do |format|
      if @return.save
        format.html { redirect_to return_url(@return), notice: "Return was successfully created." }
        format.json { render :show, status: :created, location: @return }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @return.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @return.update(return_params)
        format.html { redirect_to return_url(@return), notice: "Return was successfully updated." }
        format.json { render :show, status: :ok, location: @return }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @return.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @return.destroy!

    respond_to do |format|
      format.turbo_stream { flash.now[:success] = t(".success") }
      format.html { redirect_to returns_url, notice: "Return was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def bulk_print # post
    if params[:return_ids]
      templ_id = params[:button].split("#").last
      BulkPrintJob.perform_later("Return", params[:return_ids], templ_id, current_user.id)
      render turbo_stream: 
        turbo_stream.update(
          'modal',
          template: "shared/pending_bulk"
        )
    else
      notice = "Выберите позиции"
      redirect_to returns_url, alert: notice
    end
  end

  private

  def set_return
    @return = Return.find(params[:id])
  end

  def return_params
    params.require(:return).permit(:client_id, :company_id, :number, :return_status_id, :invoice_id, return_items_attributes: [:id, :variant_id, :price, :discount, :sum, :quantity, :vat, :_destroy])
  end
  
end
