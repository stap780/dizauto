class OrderStatusesController < ApplicationController
  load_and_authorize_resource
  before_action :set_order_status, only: %i[show edit update sort destroy]

  # GET /order_statuses or /order_statuses.json
  def index
    @search = OrderStatus.ransack(params[:q])
    @search.sorts = "position asc" if @search.sorts.empty?
    @order_statuses = @search.result(distinct: true).paginate(page: params[:page], per_page: 100)
  end

  # GET /order_statuses/1 or /order_statuses/1.json
  def show
  end

  # GET /order_statuses/new
  def new
    @order_status = OrderStatus.new
  end

  # GET /order_statuses/1/edit
  def edit
  end

  # POST /order_statuses or /order_statuses.json
  def create
    @order_status = OrderStatus.new(order_status_params)

    respond_to do |format|
      if @order_status.save
        flash.now[:success] = t(".success")
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update(OrderStatus.new, ''),
            render_turbo_flash
          ]
        end
        format.html { redirect_to order_statuses_url, notice: t(".success") }
        format.json { render :show, status: :created, location: @order_status }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @order_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /order_statuses/1 or /order_statuses/1.json
  def update
    respond_to do |format|
      if @order_status.update(order_status_params)
        flash.now[:success] = t(".success")
        format.turbo_stream do
          render turbo_stream: [
            render_turbo_flash
          ]
        end
        format.html { redirect_to order_statuses_url, notice: t(".success") }
        format.json { render :show, status: :ok, location: @order_status }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @order_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /order_statuses/1 or /order_statuses/1.json
  def destroy
    # @order_status.destroy
    @check_destroy = @order_status.destroy ? true : false
    message = if @check_destroy == true
                flash.now[:success] = t(".success")
              else
                flash.now[:notice] = @order_status.errors.full_messages.join(" ")
              end
    respond_to do |format|
      format.html { redirect_to order_statuses_url, notice: t(".success") }
      format.json { head :no_content }
      format.turbo_stream { message }
    end
  end

  def sort
    @payment_type.insert_at params[:new_position]
    head :ok
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_order_status
    @order_status = OrderStatus.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def order_status_params
    params.require(:order_status).permit(:title, :color,:position)
  end
end
