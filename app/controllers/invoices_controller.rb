class InvoicesController < ApplicationController
  load_and_authorize_resource
  before_action :set_invoice, only: %i[ show edit update destroy ]
  include SearchQueryRansack
  include DownloadExcel
  include NestedItem

  def index
    @search = Invoice.ransack(search_params)
    @search.sorts = 'id desc' if @search.sorts.empty?
    @invoices = @search.result(distinct: true).paginate(page: params[:page], per_page: 100)
    collection = @search.present? ? @search.result(distinct: true) : @invoices
    respond_to do |format|
      format.html
    end
  end

  def show; end

  def new
    if params[:order_id].present?
      order = Order.find(params[:order_id])
      @invoice = Invoice.new(company_id: order.company_id, client_id: order.client_id)
      items = order.order_items
      items.each do |inc|
        @invoice.invoice_items.build(variant_id: inc.variant.id, quantity: inc.quantity, price: inc.price, sum: (inc.quantity*inc.price))
      end
      @information = "Внимание!!! В Заказе #{order.id} присутствует Доставка стоимостью => #{order.delivery.price}"
    else
      @invoice = Invoice.new
      @invoice.invoice_items.build
    end
  end

  def edit; end

  def create
    @invoice = Invoice.new(invoice_params)

    respond_to do |format|
      if @invoice.save
        format.html { redirect_to invoices_url, notice: t('.success') }
        format.json { render :show, status: :created, location: @invoice }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @invoice.update(invoice_params)
        format.html { redirect_to invoices_url, notice: t('.success') }
        format.json { render :show, status: :ok, location: @invoice }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @invoice.destroy!

    respond_to do |format|
      format.turbo_stream { flash.now[:success] = t('.success') }
      format.html { redirect_to invoices_url, notice: t('.success') }
      format.json { head :no_content }
    end
  end

  def bulk_print # post
    if params[:invoice_ids]
      templ_id = params[:button].split("#").last
      BulkPrintJob.perform_later("Invoice", params[:invoice_ids], templ_id, current_user.id)
      render turbo_stream: 
        turbo_stream.update(
          'modal',
          template: "shared/pending_bulk"
        )
    else
      notice = "Выберите позиции"
      redirect_to invoices_url, alert: notice
    end
  end

  private
    def set_invoice
      @invoice = Invoice.find(params[:id])
    end

    def invoice_params
      params.require(:invoice).permit(:client_id,:company_id, :number, :invoice_status_id, :order_id, invoice_items_attributes: [:id, :variant_id, :price, :discount, :sum, :quantity, :vat, :_destroy])
    end

end
