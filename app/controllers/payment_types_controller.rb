class PaymentTypesController < ApplicationController
  load_and_authorize_resource
  before_action :set_payment_type, only: %i[show edit update destroy]

  # GET /payments or /payments.json
  def index
    @search = PaymentType.ransack(params[:q])
    @search.sorts = "id desc" if @search.sorts.empty?
    @payment_types = @search.result(distinct: true).paginate(page: params[:page], per_page: 100)
  end

  # GET /payments/1 or /payments/1.json
  def show
  end

  # GET /payments/new
  def new
    @payment_type = PaymentType.new
  end

  # GET /payments/1/edit
  def edit
  end

  # POST /payments or /payments.json
  def create
    @payment_type = PaymentType.new(payment_type_params)

    respond_to do |format|
      if @payment_type.save
        format.html { redirect_to payment_types_url, notice: "Payment was successfully created." }
        format.json { render :show, status: :created, location: @payment_type }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @payment_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /payments/1 or /payments/1.json
  def update
    respond_to do |format|
      if @payment_type.update(payment_type_params)
        format.html { redirect_to payment_types_url, notice: "Payment was successfully updated." }
        format.json { render :show, status: :ok, location: @payment_type }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @payment_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payments/1 or /payments/1.json
  def destroy
    @payment_type.destroy

    respond_to do |format|
      format.html { redirect_to payment_types_url, notice: "Payment was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_payment_type
    @payment_type = PaymentType.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def payment_type_params
    params.require(:payment_type).permit(:title, :margin, :desc)
  end
end
