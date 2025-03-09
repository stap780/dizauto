require 'rest-client'
require 'json'

# OrderImport < ApplicationService
class Avito::OrderImport < ApplicationService

  attr_reader :api_id, :api_secret, :base_url, :limit, :orders, :token, :item_info

  def initialize(avito, limit = 1)
    @api_id = avito.api_id
    @api_secret = avito.api_secret
    @base_url = 'https://api.avito.ru'
    @avito_name = avito.title
    @limit = limit
    @orders = nil
    @token = nil
    @item_info = nil
    @user_id = avito.profileid
  end

  def call
    import_orders
  end

  def check
    access_token
  end

  def api_item_info
    get_item_inf
  end


  private

  def import_orders
    # Fetch orders from Avito API with limit 20 and status 'on_confirmation'

    response = RestClient.get("#{@base_url}/order-management/1/orders", headers )
    # NOTICE if need limits => , params: { limit: @limit, status: 'on_confirmation' }

    if response.code == 200
      orders = JSON.parse(response.body)['orders']
      @orders = orders
      orders.each do |order_data|
        create_order(order_data)
      end
    else
      Rails.logger.error("Failed to fetch orders from Avito: #{response.body}")
    end
  end

  def headers
    {'Authorization' => "Bearer #{access_token}",'Content-Type' => 'application/json'}
  end

  def access_token
    # NOTICE Implement the logic to get the access token using @api_id and @api_secret
    data = {
      client_id: @api_id,
      client_secret: @api_secret,
      grant_type: 'client_credentials'
    }
    response = RestClient.post("#{@base_url}/token", data, { 'Content-Type' => 'application/x-www-form-urlencoded' })

    if response.code == 200
      @token = JSON.parse(response.body)['access_token']
      @token
    else
      Rails.logger.error("Failed to fetch access token from Avito: #{response.body}")
      nil
    end
  end

  def create_order(order_data)
    order_status = OrderStatus.where(position: 1).first_or_create!(title: 'New')

    payment_type = PaymentType.where(position: 1).first_or_create!(title: 'Cash')

    delivery_data = {
      title: order_data['delivery']['serviceName'],
      desc: order_data['delivery']['terminalInfo'].present? ? order_data['delivery']['terminalInfo']['address'] : '',
      price: 0
    }
    delivery_type = DeliveryType.where(title: delivery_data[:title]).first_or_create!(delivery_data)

    shippings = [{
      # name: order_data['shipping_address']['full_name'],
      # phone: order_data['shipping_address']['formatted_phone'],
      # address: order_data['shipping_address']['full_delivery_address'],
      # comments_attributes: [body: order_data['comment'], user_id: User.where(role: 'admin').first.id]
    }]

    delivery = {
      delivery_type_id: delivery_type.id,
      price: 0
    }

    order_items = []
    order_data['items'].each do |o_line|
      varbind = Varbind.where(varbindable_type: 'Avito', value: o_line['id']).take
      variant = varbind.present? ? varbind.variant : nil
      next unless variant.present?

      line_data = {
        variant_id: variant.id,
        price: o_line['prices']['price'],
        quantity: o_line['count'],
        sum: o_line['full_total_price']
      }
      order_items << line_data
    end

    comments_attributes = [
      body: "Заказ авито - #{order_data['marketplaceId']}",
      user_id: User.where(role: 'admin').first.id
    ]

    order_data = {
      client_id: Client.where(name: @avito_name).first_or_create!(name: @avito_name),
      seller_id: Company.our.first.id,
      order_status_id: order_status.id,
      payment_type_id: payment_type.id,
      delivery_attributes: delivery,
      shippings_attributes: shippings,
      order_items_attributes: order_items,
      comments_attributes: comments_attributes
    }
    Order.create!(order_data) if order_items.count.positive?
  end

  # NOTICE maybe we need this in future
  def get_item_info
    response = RestClient.get("#{@base_url}/core/v1/accounts/#{@user_id}/items/#{@item_id}", headers)

    if response.code == 200
      item_info = JSON.parse(response.body)
      @item_info = item_info
    else
      Rails.logger.error("Failed to fetch item info from Avito: #{response.body}")
      nil
    end
  end

end