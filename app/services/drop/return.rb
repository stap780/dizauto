class Drop::Return < Liquid::Drop
    def initialize(return)
      @return = return
    end
  
    def do_work # this is for check condition true/false
      "do_work"
    end
  
    def id
      @return.id
    end

    def status
        @return.return_status.present? ? @return.return_status.title : ""
    end
  
    def client
      @return.client.present? ? @return.client.attributes : []
    end
  
    def company
      @return.company.present? ? @return.company.attributes : []
    end
  
    def totalsum
      @return.return_items.present? ?  @return.return_items.sum(:sum) : ''
    end
  
    def items
      #li.attributes 
      @return.return_items.present? ? @return.return_items.map { |li| 
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
  