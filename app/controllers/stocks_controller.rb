class StocksController < ApplicationController
  load_and_authorize_resource
  before_action :set_stock, only: %i[ show edit update destroy ]

  # GET /stocks or /stocks.json
  def index
    products_with_stocks = Stock.group(:product_id).count
    products_with_stocks_ids = products_with_stocks.keys
    # @search = Stock.includes(:product).ransack(params[:q])
    @search = Product.where(id: products_with_stocks_ids).ransack(params[:q])
    # @search.sorts = "id desc" if @search.sorts.empty?
    @stocks = @search.result(distinct: true).paginate(page: params[:page], per_page: 100)
    filename = "stocks.xlsx"
    collection = @search.present? ? @search.result(distinct: true) : @stocks
    respond_to do |format|
      format.html
      format.zip do
        CreateZipXlsxJob.perform_later(collection.ids, {model: "Stock",
                                                          current_user_id: current_user.id,
                                                          filename: filename,
                                                          template: "stocks/index"})
        flash[:success] = t ".success"
        redirect_to stocks_path
      end
    end
  end

  # GET /stocks/1 or /stocks/1.json
  def show
  end

  # GET /stocks/new
  def new
    @stock = Stock.new
  end

  # GET /stocks/1/edit
  def edit
  end

  # POST /stocks or /stocks.json
  def create
    @stock = Stock.new(stock_params)

    respond_to do |format|
      if @stock.save
        format.html { redirect_to stock_url(@stock), notice: "Stock was successfully created." }
        format.json { render :show, status: :created, location: @stock }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @stock.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /stocks/1 or /stocks/1.json
  def update
    respond_to do |format|
      if @stock.update(stock_params)
        format.html { redirect_to stock_url(@stock), notice: "Stock was successfully updated." }
        format.json { render :show, status: :ok, location: @stock }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @stock.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stocks/1 or /stocks/1.json
  def destroy
    @stock.destroy!

    respond_to do |format|
      format.html { redirect_to stocks_url, notice: "Stock was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_stock
      @stock = Stock.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def stock_params
      params.require(:stock).permit(:product_id, :user_id, :stockable_id, :stockable_type, :move, :value)
    end
end
