# LossStatusesController
class LossStatusesController < ApplicationController
  load_and_authorize_resource
  before_action :set_loss_status, only: %i[ show edit update destroy ]

  def index
    @search = LossStatus.ransack(params[:q])
    @search.sorts = 'position asc' if @search.sorts.empty?
    @loss_statuses = @search.result(distinct: true).paginate(page: params[:page], per_page: 100)
  end

  def show; end

  def new
    @loss_status = LossStatus.new
  end

  def edit; end

  def create
    @loss_status = LossStatus.new(loss_status_params)

    respond_to do |format|
      if @loss_status.save
        flash.now[:success] = t('.success')
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update(LossStatus.new, ''),
            render_turbo_flash
          ]
        end
        format.html { redirect_to loss_statuses_url, notice: t('.success') }
        format.json { render :show, status: :created, location: @loss_status }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @loss_status.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @loss_status.update(loss_status_params)
        flash.now[:success] = t('.success')
        format.turbo_stream do
          render turbo_stream: [
            render_turbo_flash
          ]
        end
        format.html { redirect_to loss_statuses_url, notice: t('.success') }
        format.json { render :show, status: :ok, location: @loss_status }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @loss_status.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @check_destroy = @loss_status.destroy ? true : false
    message = if @check_destroy == true
                flash.now[:success] = t('.success')
              else
                flash.now[:notice] = @loss_status.errors.full_messages.join(' ')
              end
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          render_turbo_flash
        ]
      end
      format.html { redirect_to loss_statuses_url, notice: t('.success') }
      format.json { head :no_content }
    end
  end

  def sort
    @loss_status.insert_at params[:new_position]
    head :ok
  end

  private

  def set_loss_status
    @loss_status = LossStatus.find(params[:id])
  end

  def loss_status_params
    params.require(:loss_status).permit(:title, :color, :position)
  end
end
