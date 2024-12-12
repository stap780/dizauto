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
    # :company_id, :order_status_id, :client_id, :manager_id, :payment_type_id, :delivery_type_id,
    # order_items_attributes: [:id, :variant_id, :price, :discount, :sum, :quantity, :_destroy]
    # validates :order_status_id
    # validates :payment_type_id
    # validates :delivery_type_id
    # validates :client_id


  end

end