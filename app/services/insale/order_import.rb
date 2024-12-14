# frozen_string_literal: true

# Insale
class Insale::OrderImport < ApplicationService

  def initialize(datas)
    @datas = datas
    @client = nil
  end

  def call
    create_client
    create_order
  end

  private

  def create_client
    # :surname, :name, :middlename, :phone, :email
    # validates :name, presence: true
    # validates :email, presence: true
    # validates :email, uniqueness: true
    client_id = @datas['client']['id']
    client_email = @datas['client']['email'].present? ? @datas['client']['email'] : "#{client_id}@mail.ru"
    client_phone = @datas['client']['phone']
    check_client = client_email.present? ? Client.find_by_email(client_email) : Client.find_by_insale_client_id(client_id)
    client_data = {
      insale_client_id: client_id,
      email: client_email,
      name: @datas['client']['name'],
      surname: @datas['client']['surname'],
      phone: client_phone
    }
    check_client.update(client_data.except!(:email)) if check_client.present?
    @client = check_client.present? ? check_client : Client.create!(client_data)
  end

  def create_order
    # order_attributes: [:company_id, :order_status_id, :client_id, :manager_id, :payment_type_id, :delivery_type_id]
    # order_items_attributes: [:id, :variant_id, :price, :discount, :sum, :quantity]
    # validates :order_status_id
    # validates :payment_type_id
    # validates :delivery_type_id
    # validates :client_id
    order_status_id = OrderStatus.first.id
    payment_type_id = PaymentType.first.id
    delivery_type_id = DeliveryType.first.id
    data = {
      order_status_id: order_status_id,
      payment_type_id: payment_type_id,
      delivery_type_id: delivery_type_id,
      client_id: @client.id,
      order_items_attributes: []
    }
    data_order_items = {}
    @datas['order_lines'].each_with_index do |o_line, index|
      item = {}
      item[:variant_id] = find_variant_id(o_line)
      item[:price] = o_line['full_total_price']
      item[:quantity] = o_line['quantity']
      data_order_items[index] = item
    end
    data[:order_items_attributes] = data_order_items
    Order.create!(data)
  end

  def find_variant_id(o_line)
    Variant.where(insale_id: o_line['variant_id']).present? ? Variant.where(insale_id: o_line['variant_id']).take.id : Variant.where(barcode: o_line['barcode']).take.id
  end

end