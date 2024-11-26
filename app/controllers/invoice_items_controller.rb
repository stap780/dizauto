class InvoiceItemsController < ApplicationController
  load_and_authorize_resource
  before_action :set_invoice_item, only: %i[ show edit update destroy ]

  def index
    @invoice_items = InvoiceItem.all
  end

  def show
  end

  def new
    @invoice_item = InvoiceItem.new
  end

  def edit
  end

  def create
    @invoice_item = InvoiceItem.new(invoice_item_params)

    respond_to do |format|
      if @invoice_item.save
        format.html { redirect_to invoice_item_url(@invoice_item), notice: "Invoice item was successfully created." }
        format.json { render :show, status: :created, location: @invoice_item }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @invoice_item.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @invoice_item.update(invoice_item_params)
        format.html { redirect_to invoice_item_url(@invoice_item), notice: "Invoice item was successfully updated." }
        format.json { render :show, status: :ok, location: @invoice_item }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @invoice_item.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @invoice_item.destroy!

    respond_to do |format|
      format.html { redirect_to invoice_items_url, notice: "Invoice item was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_invoice_item
      @invoice_item = InvoiceItem.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def invoice_item_params
      params.require(:invoice_item).permit(:variant_id, :price, :discount, :sum, :quantity, :vat, :invoice_id)
    end
end
