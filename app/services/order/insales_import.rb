# Service to import Order from Insales

class Order::InsalesImport < ApplicationService

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
    client_email = @datas['client']['email'].present? ? @datas['client']['email'] : "#{@datas['client']['id']}@mail.ru"
    client_phone = @datas['client']['phone']
    # check_client = client_email.present? ? Client.find_by_email(client_email) : Client.find_by_phone(client_phone)
    client_data = {
      email: client_email,
      name: @datas['client']['name'] ||= "api_client_#{@datas['client']['id']}",
      phone: client_phone
    }
    client = Client.find_by_email(client_email)
    @client = client.present? ? client : Client.create!(client_data)
  end

  def create_order
    # @datas['order_lines'].each do |o_line|
    #   product = Product.find_by_insid(o_line['product_id']).present? ? Product.find_by_insid(o_line['product_id']) :
    #                                                                   Product.create!(insid: o_line['product_id'],
    #                                                                     title: o_line['title'])
    #   puts "insint order product => #{product.inspect}"
    #   variant = product.variants.where(insid: o_line['variant_id']).present? ? product.variants.where(insid: o_line['variant_id'])[0] :
    #                                                                         product.variants.create!(insid: o_line['variant_id'],
    #                                                                           sku: o_line['sku'],
    #                                                                           price: o_line['sale_price'])
    #   line = mycase.lines.where(product_id: product.id, variant_id: variant.id)
    #   if line.present?
    #     line.first.update!(quantity: o_line['quantity'], price: o_line['full_total_price'])
    #   else
    #     mycase.lines.create!(product_id: product.id, variant_id: variant.id, quantity: o_line['quantity'], price: o_line['full_total_price'])
    #   end
    # end
  end

end
