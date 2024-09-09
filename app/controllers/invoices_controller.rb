class InvoicesController < ApplicationController
  load_and_authorize_resource
  before_action :set_invoice, only: %i[ show edit update destroy ]
  include SearchQueryRansack
  include DownloadExcel

  def index
    @search = Invoice.ransack(search_params)
    @search.sorts = "id desc" if @search.sorts.empty?
    @invoices = @search.result(distinct: true).paginate(page: params[:page], per_page: 100)
    collection = @search.present? ? @search.result(distinct: true) : @invoices
    respond_to do |format|
      format.html
    end
  end

  def show
  end

  def new
    if params[:order_id].present?
      order = Order.find(params[:order_id])
      @invoice = Invoice.new(company_id: order.company_id, client_id: order.client_id)
      items = order.order_items
      items.each do |inc|
        @invoice.invoice_items.build(product_id: inc.product.id, quantity: inc.quantity, price: inc.price, sum: (inc.quantity*inc.price))
      end
    else
      @invoice = Invoice.new
      @invoice.invoice_items.build
    end
  end

  def edit
  end

  def create
    @invoice = Invoice.new(invoice_params)

    respond_to do |format|
      if @invoice.save
        format.html { redirect_to invoices_url, notice: t(".success") }
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
        format.html { redirect_to invoices_url, notice: t(".success") }
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
      format.turbo_stream { flash.now[:success] = t(".success") }
      format.html { redirect_to invoices_url, notice: t(".success") }
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

  def slimselect_nested_item # GET
    target = params[:turboId]
    invoice_item = InvoiceItem.find_by(id: target.remove("invoice_item_"))
    product = Product.find(params[:selected_id])
    child_index = target.remove("invoice_item_")

    if invoice_item.present?
      helpers.fields model: Invoice.new do |f|
        f.fields_for :invoice_items, invoice_item do |ff|
          render turbo_stream: turbo_stream.replace(
            target,
            partial: "invoice_items/form_data",
            locals: {f: ff, product: product, child_index: child_index}
          )
        end
      end
    else
      helpers.fields model: Invoice.new do |f|
        f.fields_for :invoice_items, InvoiceItem.new, child_index: child_index do |ff|
          render turbo_stream: turbo_stream.replace(
            target,
            partial: "invoice_items/form_data",
            locals: {f: ff, product: product, child_index: child_index}
          )
        end
      end
    end
  end

  def new_nested # GET
    child_index = Time.now.to_i
    helpers.fields model: Invoice.new do |f|
      f.fields_for :invoice_items, InvoiceItem.new, child_index: child_index do |ff|
        render turbo_stream: turbo_stream.append(
          "invoice_items",
          partial: "invoice_items/form_data",
          locals: {f: ff, product: nil, child_index: child_index}
        )
      end
    end
  end

  def remove_nested # POST
    InvoiceItem.find_by(id: params[:invoice_item_id]).delete if params[:invoice_item_id].present?
    @remove_element = params[:remove_element]
    respond_to do |format|
      format.turbo_stream { flash.now[:notice] = t(".success") }
    end
  end

  private
    def set_invoice
      @invoice = Invoice.find(params[:id])
    end

    def invoice_params
      params.require(:invoice).permit(:client_id,:company_id, :number, :invoice_status_id, :order_id, invoice_items_attributes: [:id, :product_id, :price, :discount, :sum, :quantity, :vat, :_destroy])
    end

end
