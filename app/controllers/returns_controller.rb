class ReturnsController < ApplicationController
  load_and_authorize_resource
  before_action :set_return, only: %i[ show edit update destroy ]

  # GET /returns or /returns.json
  def index
    @search = Return.ransack(params[:q])
    @search.sorts = "id desc" if @search.sorts.empty?
    @returns = @search.result(distinct: true).paginate(page: params[:page], per_page: 100)
    # filename = "returns.xlsx"
    collection = @search.present? ? @search.result(distinct: true) : @returns
    respond_to do |format|
      format.html
      # format.zip do
      #   CreateZipXlsxJob.perform_later(collection.ids, {model: "Return",
      #                                                     current_user_id: current_user.id,
      #                                                     filename: filename,
      #                                                     template: "returns/index"})
      #   flash[:success] = t ".success"
      #   redirect_to orders_path
      # end
    end
  end

  def download
    filename = "returns.xlsx"
    collection_ids = params[:return_ids].present? ? params[:return_ids] : Return.with_images.pluck(:id)
    CreateZipXlsxJob.perform_later(collection_ids, {  model: "Return",
                                                      current_user_id: current_user.id,
                                                      filename: filename,
                                                      template: "returns/index"})
    render turbo_stream: 
      turbo_stream.update(
        'modal',
        template: "shared/pending_bulk"
      )
  end


  def show
  end

  # GET /returns/new
  def new
    if params[:invoice_id].present?
      invoice = Invoice.find(params[:invoice_id])
      @return = Return.new(company_id: invoice.company_id, client_id: invoice.client_id)
      items = invoice.invoice_items
      items.each do |inc|
        @return.return_items.build(product_id: inc.product.id, quantity: inc.quantity, price: inc.price, sum: (inc.quantity*inc.price))
      end
    else
      @return = Return.new
      @return.return_items.build
    end
  end

  # GET /returns/1/edit
  def edit
  end

  # POST /returns or /returns.json
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

  # PATCH/PUT /returns/1 or /returns/1.json
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

  # DELETE /returns/1 or /returns/1.json
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

  def slimselect_nested_item # GET
    target = params[:turboId]
    return_item = ReturnItem.find_by(id: target.remove("return_item_"))
    product = Product.find(params[:selected_id])
    child_index = target.remove("return_item_")

    if return_item.present?
      helpers.fields model: Return.new do |f|
        f.fields_for :return_items, return_item do |ff|
          render turbo_stream: turbo_stream.replace(
            target,
            partial: "return_items/form_data",
            locals: {f: ff, product: product, child_index: child_index}
          )
        end
      end
    else
      helpers.fields model: Return.new do |f|
        f.fields_for :return_items, ReturnItem.new, child_index: child_index do |ff|
          render turbo_stream: turbo_stream.replace(
            target,
            partial: "return_items/form_data",
            locals: {f: ff, product: product, child_index: child_index}
          )
        end
      end
    end
  end

  def new_nested # GET
    child_index = Time.now.to_i
    helpers.fields model: Return.new do |f|
      f.fields_for :return_items, ReturnItem.new, child_index: child_index do |ff|
        render turbo_stream: turbo_stream.append(
          "return_items",
          partial: "return_items/form_data",
          locals: {f: ff, product: nil, child_index: child_index}
        )
      end
    end
  end

  def remove_nested # POST
    ReturnItem.find_by(id: params[:return_item_id]).delete if params[:return_item_id].present?
    @remove_element = params[:remove_element]
    respond_to do |format|
      format.turbo_stream { flash.now[:notice] = t(".success") }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_return
      @return = Return.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def return_params
      params.require(:return).permit(:client_id, :company_id, :number, :return_status_id, :invoice_id, return_items_attributes: [:id, :product_id, :price, :discount, :sum, :quantity, :vat, :_destroy])
    end
end
