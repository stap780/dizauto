class Drop::Order < Liquid::Drop
    def initialize(order)
      @order = order
    end
  
    def do_work # this is for check condition true/false
      "do_work"
    end
  
    def id
      @order.id
    end

    def status
        @order.order_status.present? ? @order.order_status.title : ""
    end
  
    def client
      @order.client.present? ? @order.client.attributes : []
    end
  
    def company
      @order.company.present? ? @order.company.attributes : []
    end

    def manager
        @order.manager.present? ?  @order.manager.attributes : []
    end
  
    def payment_type
        @order.payment_type.present? ?  @order.payment_type.title : ''
    end

    def delivery_type
        @order.delivery_type.present? ?  @order.delivery_type.title : ''
    end
  
    def totalsum
      @order.order_items.present? ?  @order.order_items.sum(:sum) : ''
    end
  
    def items
      #li.attributes 
      @order.order_items.present? ? @order.order_items.map { |li| 
        {
          "id"=>li.id,
          "title"=>li.product.title, 
          "price"=>li.price, 
          "discount"=>li.discount, 
          "sum"=> li.sum,
          "quantity"=>li.quantity,
          "vat"=>li.vat
        }
      } : []
    end
  

  end
  