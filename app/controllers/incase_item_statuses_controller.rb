# IncaseItemStatusesController
class IncaseItemStatusesController < ApplicationController
  load_and_authorize_resource
  before_action :set_incase_item_status, only: %i[show edit update sort destroy]

  def index
    @search = IncaseItemStatus.ransack(params[:q])
    @search.sorts = 'position asc' if @search.sorts.empty?
    @incase_item_statuses = @search.result(distinct: true).paginate(page: params[:page], per_page: 100)
  end

  def show; end

  def new
    @incase_item_status = IncaseItemStatus.new
  end

  def edit; end

  def create
    @incase_item_status = IncaseItemStatus.new(incase_item_status_params)

    respond_to do |format|
      if @incase_item_status.save
        flash.now[:success] = t('.success')
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update(IncaseItemStatus.new, ''),
            render_turbo_flash
          ]
        end
        format.html { redirect_to incase_item_statuses_url, notice: t('.success') }
        format.json { render :show, status: :created, location: @incase_item_status }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @incase_item_status.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @incase_item_status.update(incase_item_status_params)
        flash.now[:success] = t('.success')
        format.turbo_stream do
          render turbo_stream: [
            render_turbo_flash
          ]
        end
        format.html { redirect_to incase_item_statuses_url, notice: t('.success') }
        format.json { render :show, status: :ok, location: @incase_item_status }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @incase_item_status.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @incase_item_status.destroy

    respond_to do |format|
      format.html { redirect_to incase_item_statuses_url, notice: t('.success') }
      format.json { head :no_content }
      format.turbo_stream { flash.now[:success] = t('.success') }
    end
  end

  def sort
    # puts "sort params => "+params.to_s
    # position = @incase_item_status.find_by( position: params[:old_position] )
    @incase_item_status.insert_at params[:new_position]
    head :ok
  end

  private

  def set_incase_item_status
    @incase_item_status = IncaseItemStatus.find(params[:id])
  end

  def incase_item_status_params
    params.require(:incase_item_status).permit(:title, :color, :position)
  end
end
