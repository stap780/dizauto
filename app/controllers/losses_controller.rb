class LossesController < ApplicationController
  load_and_authorize_resource
  before_action :set_loss, only: %i[ show edit update destroy ]

  # GET /losses or /losses.json
  def index
    @search = Loss.ransack(params[:q])
    @search.sorts = "id desc" if @search.sorts.empty?
    @losses = @search.result(distinct: true).paginate(page: params[:page], per_page: 100)
    filename = "losses.xlsx"
    collection = @search.present? ? @search.result(distinct: true) : @stock_transfers
    respond_to do |format|
      format.html
      format.zip do
        CreateZipXlsxJob.perform_later(collection.ids, {model: "Loss",
                                                          current_user_id: current_user.id,
                                                          filename: filename,
                                                          template: "losses/index"})
        flash[:success] = t ".success"
        redirect_to losses_url
      end
    end
  end

  # GET /losses/1 or /losses/1.json
  def show
  end

  # GET /losses/new
  def new
    @loss = Loss.new
    if params[:stock_transfer_id].present?
      stock_transfer = StockTransfer.find(params[:stock_transfer_id])
      @loss = Loss.new( manager_id: current_user.id, warehouse_id: stock_transfer.origin_warehouse_id, stock_transfer_id: params[:stock_transfer_id])
      items = stock_transfer.stock_transfer_items
      items.each do |inc|
        @loss.loss_items.build(product_id: inc.product.id, quantity: inc.quantity, price: inc.price)
      end
    else
      @loss = Loss.new
      @loss.loss_items.build
    end
  end

  # GET /losses/1/edit
  def edit
  end

  # POST /losses or /losses.json
  def create
    @loss = Loss.new(loss_params)

    respond_to do |format|
      if @loss.save
        format.html { redirect_to losses_url, notice: "Loss was successfully created." }
        format.json { render :show, status: :created, location: @loss }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @loss.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /losses/1 or /losses/1.json
  def update
    respond_to do |format|
      if @loss.update(loss_params)
        format.html { redirect_to losses_url, notice: "Loss was successfully updated." }
        format.json { render :show, status: :ok, location: @loss }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @loss.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /losses/1 or /losses/1.json
  def destroy
    @loss.destroy!

    respond_to do |format|
      format.html { redirect_to losses_url, notice: "Loss was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def slimselect_nested_item # GET
    target = params[:turboId]
    loss_item = LossItem.find_by(id: target.remove("loss_item_"))
    product = Product.find(params[:selected_id])
    child_index = target.remove("loss_item_")
    warehouse_id = params[:warehouse_id]

    if loss_item.present?
      helpers.fields model: Loss.new do |f|
        f.fields_for :loss_items, loss_item do |ff|
          render turbo_stream: turbo_stream.replace(
            target,
            partial: "loss_items/form_data",
            locals: {f: ff, product: product, child_index: child_index, our_dom_id: target, warehouse_id: warehouse_id}
          )
        end
      end
    else
      helpers.fields model: Loss.new do |f|
        f.fields_for :loss_items, LossItem.new, child_index: child_index do |ff|
          render turbo_stream: turbo_stream.replace(
            target,
            partial: "loss_items/form_data",
            locals: {f: ff, product: product, child_index: child_index, our_dom_id: target, warehouse_id: warehouse_id}
          )
        end
      end
    end
  end

  def new_nested # GET
    child_index = Time.now.to_i
    helpers.fields model: Loss.new do |f|
      f.fields_for :loss_items, LossItem.new, child_index: child_index do |ff|
        render turbo_stream: turbo_stream.append(
          "loss_items",
          partial: "loss_items/form_data",
          locals: {f: ff, product: nil, our_dom_id: "loss_item_#{child_index}_loss", warehouse_id: nil}
        )
      end
    end
  end

  def remove_nested # POST
    LossItem.find_by(id: params[:loss_item_id]).delete if params[:loss_item_id].present?
    @remove_element = params[:remove_element]
    respond_to do |format|
      format.turbo_stream { flash.now[:notice] = t(".success") }
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_loss
      @loss = Loss.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def loss_params
      params.require(:loss).permit(:loss_status_id, :title, :date, :warehouse_id, :manager_id, :stock_transfer_id,
      loss_items_attributes: [:id, :product_id, :quantity, :price, :vat, :sum, :_destroy])
    end
end
