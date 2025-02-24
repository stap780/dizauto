require 'rest-client'
require 'json'

# OrderImport < ApplicationService
class Avito::OrderImport < ApplicationService

attr_reader :api_id, :api_secret, :base_url, :limit, :orders, :token

  def initialize(avito, limit = 1)
    @api_id = avito.api_id
    @api_secret = avito.api_secret
    @base_url = 'https://api.avito.ru'
    @limit = limit
    @orders = nil
    @token = nil
  end

  def call
    import_orders
  end

  def check
    access_token
  end

private

  def import_orders
    # Fetch orders from Avito API with limit 20 and status 'on_confirmation'
    response = RestClient.get("#{@base_url}/order-management/1/orders", { params: { limit: @limit, status: 'on_confirmation' }, headers: headers })
    if response.code == 200
      orders = JSON.parse(response.body)['orders']
      @orders = orders
      orders.each do |order_data|
        # import_order(order_data)
      end
    else
      Rails.logger.error("Failed to fetch orders from Avito: #{response.body}")
    end
  end

  def headers
    {
      'Authorization' => "Bearer #{access_token}",
      'Content-Type' => 'application/json'
    }
  end

  def access_token
    # Implement the logic to get the access token using @api_id and @api_secret
    data = {
      client_id: @api_id,
      client_secret: @api_secret,
      grant_type: 'client_credentials'
    }
    response = RestClient.post("#{@base_url}/token", data , { 'Content-Type' => 'application/x-www-form-urlencoded' })

    if response.code == 200
      @token = JSON.parse(response.body)['access_token']
      @token
    else
      Rails.logger.error("Failed to fetch access token from Avito: #{response.body}")
      nil
    end
  end

  def import_order(order_data)
    # Example: Create or update order in your application
    # order = Order.find_or_initialize_by(avito_id: order_data['id'])
    order = Order.find_by(avito_id: order_data['id'])
    order.update(
      client_name: order_data['client_name'],
      order_type: order_data['order_type'],
      order_sum: order_data['order_sum'],
      created_at: order_data['created_at']
    )
  end

end