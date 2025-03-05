# StockTransferStatusesController
class StockTransferStatusesController < ApplicationController
  load_and_authorize_resource
  before_action :set_stock_transfer_status, only: %i[ show edit update destroy ]

  def index
    @search = StockTransferStatus.ransack(params[:q])
    @search.sorts = 'position asc' if @search.sorts.empty?
    @stock_transfer_statuses = @search.result(distinct: true).paginate(page: params[:page], per_page: 100)
  end

  def show; end

  def new
    @stock_transfer_status = StockTransferStatus.new
  end

  def edit; end

  def create
    @stock_transfer_status = StockTransferStatus.new(stock_transfer_status_params)

    respond_to do |format|
      if @stock_transfer_status.save
        flash.now[:success] = t('.success')
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update(StockTransferStatus.new, ''),
            render_turbo_flash
          ]
        end
        format.html { redirect_to stock_transfer_statuses_url, notice: t('.success') }
        format.json { render :show, status: :created, location: @stock_transfer_status }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @stock_transfer_status.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @stock_transfer_status.update(stock_transfer_status_params)
        flash.now[:success] = t('.success')
        format.turbo_stream do
          render turbo_stream: [
            render_turbo_flash
          ]
        end
        format.html { redirect_to stock_transfer_statuses_url, notice: t('.success') }
        format.json { render :show, status: :ok, location: @stock_transfer_status }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @stock_transfer_status.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    # @stock_transfer_status.destroy!
    @check_destroy = @stock_transfer_status.destroy ? true : false
    message = if @check_destroy == true
                flash.now[:success] = t('.success')
              else
                flash.now[:notice] = @stock_transfer_status.errors.full_messages.join(' ')
              end
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          render_turbo_flash
        ]
      end
      format.html { redirect_to stock_transfer_statuses_url, notice: t('.success') }
      format.json { head :no_content }
    end
  end

  def sort
    @stock_transfer_status.insert_at params[:new_position]
    head :ok
  end

  private

  def set_stock_transfer_status
    @stock_transfer_status = StockTransferStatus.find(params[:id])
  end

  def stock_transfer_status_params
    params.require(:stock_transfer_status).permit(:title, :color, :position)
  end

end
