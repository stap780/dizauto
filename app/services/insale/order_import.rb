  # Service to import Order from Insales
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
      insid = @datas['client']['id']
      email = @datas['client']['email'].present? ? @datas['client']['email'] : "#{@datas['client']['id']}@mail.ru"
      phone = @datas['client']['phone']
      name = @datas['client']['name'].present? ? @datas['client']['name'] : "api_client_#{insid}"
      surname = @datas['client']['surname']
      client_data = {
        email: email,
        name: name,
        surname: surname,
        phone: phone,
        insid: insid
      }

      client = Client.find_by_insid(insid).present? ? Client.find_by_insid(insid) : Client.find_by_email(email)
      @client = client.present? ? client : Client.create!(client_data)
    end

    def create_order
      order_status = OrderStatus.where(position: 1).first_or_create!(title: 'New')
      payment_data = {
        title: @datas['payment_title'],
        desc: @datas['payment_description']
      }
      payment_type = PaymentType.where(title: payment_data[:title]).first_or_create!(payment_data)
      delivery_data = {
        title: @datas['delivery_title'],
        desc: @datas['delivery_description'],
        price: @datas['full_delivery_price']
      }
      delivery_type = DeliveryType.where(title: delivery_data[:title]).first_or_create!(delivery_data)

      order_items = []
      shippings = [{
        name: @datas['shipping_address']['full_name'],
        phone: @datas['shipping_address']['formatted_phone'],
        address: @datas['shipping_address']['full_delivery_address'],
        comments_attributes: [body: @datas['comment'], user_id: User.where(role: 'admin').first.id]
      }]
      delivery = {
        delivery_type_id: delivery_type.id,
        price: @datas['full_delivery_price']
      }

      @datas['order_lines'].each do |o_line|
        variant = Variant.find_by_insid(o_line['variant_id']).present? ? Variant.find_by_insid(o_line['variant_id']) : Variant.find_by_barcode(o_line['sku'])
        line_data = {
          variant_id: variant.id,
          price: o_line['full_sale_price'],
          quantity: o_line['quantity'],
          sum: o_line['full_total_price']
        }
        order_items << line_data
      end

      order_data = {
        client_id: @client.id,
        seller_id: Company.our.first.id,
        order_status_id: order_status.id,
        payment_type_id: payment_type.id,
        delivery_attributes: delivery,
        shippings_attributes: shippings,
        order_items_attributes: order_items
      }
      Order.create!(order_data)
    end

  end
