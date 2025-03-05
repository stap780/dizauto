# InventoryStatusesController
class InventoryStatusesController < ApplicationController
  load_and_authorize_resource
  before_action :set_inventory_status, only: %i[ show edit update destroy ]

  def index
    @search = InventoryStatus.ransack(params[:q])
    @search.sorts = 'position asc' if @search.sorts.empty?
    @inventory_statuses = @search.result(distinct: true).paginate(page: params[:page], per_page: 100)
  end

  def show;end

  def new
    @inventory_status = InventoryStatus.new
  end

  def edit;end

  def create
    @inventory_status = InventoryStatus.new(inventory_status_params)

    respond_to do |format|
      if @inventory_status.save
        flash.now[:success] = t('.success')
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update(InventoryStatus.new, ''),
            render_turbo_flash
          ]
        end
        format.html { redirect_to inventory_statuses_url, notice: t('.success') }
        format.json { render :show, status: :created, location: @inventory_status }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @inventory_status.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @inventory_status.update(inventory_status_params)
        flash.now[:success] = t('.success')
        format.turbo_stream do
          render turbo_stream: [
            render_turbo_flash
          ]
        end
        format.html { redirect_to inventory_statuses_url, notice: t('.success') }
        format.json { render :show, status: :ok, location: @inventory_status }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @inventory_status.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @check_destroy = @inventory_status.destroy ? true : false
    message = if @check_destroy == true
                flash.now[:success] = t('.success')
              else
                flash.now[:notice] = @inventory_status.errors.full_messages.join(' ')
              end
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          render_turbo_flash
        ]
      end
      format.html { redirect_to inventory_statuses_url, notice: t('.success') }
      format.json { head :no_content }
    end
  end

  def sort
    @inventory_status.insert_at params[:new_position]
    head :ok
  end

  private

  def set_inventory_status
    @inventory_status = InventoryStatus.find(params[:id])
  end

  def inventory_status_params
    params.require(:inventory_status).permit(:title, :color, :position)
  end
end
