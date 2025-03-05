# SupplyStatusesController < ApplicationController
class SupplyStatusesController < ApplicationController
  load_and_authorize_resource
  before_action :set_supply_status, only: %i[show edit update destroy]

  def index
    @search = SupplyStatus.ransack(params[:q])
    @search.sorts = 'position asc' if @search.sorts.empty?
    @supply_statuses = @search.result(distinct: true).paginate(page: params[:page], per_page: 100)
  end

  def show; end

  def new
    @supply_status = SupplyStatus.new
  end

  def edit; end

  def create
    @supply_status = SupplyStatus.new(supply_status_params)

    respond_to do |format|
      if @supply_status.save
        flash.now[:success] = t('.success')
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update(SupplyStatus.new, ''),
            render_turbo_flash
          ]
        end
        format.html { redirect_to supply_statuses_url, notice: t('.success') }
        format.json { render :show, status: :created, location: @supply_status }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @supply_status.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @supply_status.update(supply_status_params)
        flash.now[:success] = t('.success')
        format.turbo_stream do
          render turbo_stream: [
            render_turbo_flash
          ]
        end
        format.html { redirect_to supply_statuses_url, notice: t('.success') }
        format.json { render :show, status: :ok, location: @supply_status }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @supply_status.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @check_destroy = @supply_status.destroy ? true : false
    message = if @check_destroy == true
                flash.now[:success] = t('.success')
              else
                flash.now[:notice] = @supply_status.errors.full_messages.join(' ')
              end

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          render_turbo_flash
        ]
      end
      format.html { redirect_to supply_statuses_url, notice: t('.success') }
      format.json { head :no_content }
    end
  end

  def sort
    @supply_status.insert_at params[:new_position]
    head :ok
  end

  private

  def set_supply_status
    @supply_status = SupplyStatus.find(params[:id])
  end

  def supply_status_params
    params.require(:supply_status).permit(:title, :color, :position)
  end
end
