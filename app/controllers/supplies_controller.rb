# frozen_string_literal: true

# SuppliesController handles the CRUD operations for supplies.
class SuppliesController < ApplicationController
  load_and_authorize_resource
  before_action :set_supply, only: %i[show edit update destroy]
  include ActionView::RecordIdentifier
  include SearchQueryRansack
  include DownloadExcel
  include NestedItem

  def index
    @search = Supply.includes(:company, :supply_items).ransack(search_params)
    @search.sorts = 'id desc' if @search.sorts.empty?
    @supplies = @search.result(distinct: true).paginate(page: params[:page], per_page: 100)
    respond_to(&:html)
  end

  def show; end

  def new
    if params[:incase_id].present?
      incase = Incase.find(params[:incase_id])
      @supply = Supply.new(company_id: incase.company_id, manager_id: current_user.id)
      p_status_id = params[:incase_item_status_id]
      items = p_status_id.present? ? incase.incase_items.where(incase_item_status_id: p_status_id) : incase.incase_items
      items.each do |inc|
        @supply.supply_items.build(variant_id: inc.variant.id, quantity: inc.quantity, price: inc.price)
      end
    else
      @supply = Supply.new
      @supply.supply_items.build
    end
  end

  def edit; end

  def create
    @supply = Supply.new(supply_params)

    respond_to do |format|
      if @supply.save
        format.html { redirect_to supplies_url, notice: 'Supply was successfully created.' }
        format.json { render :show, status: :created, location: @supply }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @supply.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @supply.update(supply_params)
        format.html { redirect_to supplies_url, notice: 'Supply was successfully updated.' }
        format.json { render :show, status: :ok, location: @supply }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @supply.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @supply.destroy

    respond_to do |format|
      format.html { redirect_to supplies_url, notice: 'Supply was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_supply
    @supply = Supply.find(params[:id])
  end

  def supply_params
    params.require(:supply).permit(
      :buyer_id,
      :company_id,
      :title,
      :in_number,
      :in_date,
      :supply_status_id,
      :manager_id,
      :warehouse_id,
      supply_items_attributes: %i[id variant_id quantity price vat sum _destroy]
    )
  end
end
