# frozen_string_literal: true

# PaymentTypesController
class PaymentTypesController < ApplicationController
  load_and_authorize_resource
  before_action :set_payment_type, only: %i[show edit update sort destroy]

  def index
    @search = PaymentType.ransack(params[:q])
    @search.sorts = 'position asc' if @search.sorts.empty?
    @payment_types = @search.result(distinct: true).paginate(page: params[:page], per_page: 100)
  end

  def show; end

  def new
    @payment_type = PaymentType.new
  end

  def edit; end

  def create
    @payment_type = PaymentType.new(payment_type_params)

    respond_to do |format|
      if @payment_type.save
        flash.now[:success] = t('.success')
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update(PaymentType.new, ''),
            render_turbo_flash
          ]
        end
        format.html { redirect_to payment_types_url, notice: t('.success') }
        format.json { render :show, status: :created, location: @payment_type }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @payment_type.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @payment_type.update(payment_type_params)
        flash.now[:success] = t(".success")
        format.turbo_stream do
          render turbo_stream: [
            render_turbo_flash
          ]
        end
        format.html { redirect_to payment_types_url, notice: t('.success') }
        format.json { render :show, status: :ok, location: @payment_type }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @payment_type.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @check_destroy = @payment_type.destroy ? true : false
    if @check_destroy == true
      flash.now[:success] = t('.success')
    else
      flash.now[:notice] = @payment_type.errors.full_messages.join(' ')
    end
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          render_turbo_flash
        ]
      end
      format.html { redirect_to payment_types_url, notice: t('.success') }
      format.json { head :no_content }
    end
  end

  def sort
    @payment_type.insert_at params[:new_position]
    head :ok
  end

  private

  def set_payment_type
    @payment_type = PaymentType.find(params[:id])
  end

  def payment_type_params
    params.require(:payment_type).permit(:title, :margin, :desc, :position)
  end
end
