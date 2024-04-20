class Drop::Return < Liquid::Drop
    def initialize(myreturn)
      @myreturn = myreturn
    end
  
    def do_work # this is for check condition true/false
      "do_work"
    end
  
    def id
      @myreturn.id
    end

    def status
        @myreturn.myreturn_status.present? ? @myreturn.myreturn_status.title : ""
    end
  
    def client
      @myreturn.client.present? ? @myreturn.client.attributes : []
    end
  
    def company
      @myreturn.company.present? ? @myreturn.company.attributes : []
    end
  
    def totalsum
      @myreturn.myreturn_items.present? ?  @myreturn.myreturn_items.sum(:sum) : ''
    end
  
    def items
      #li.attributes 
      @myreturn.myreturn_items.present? ? @myreturn.myreturn_items.map { |li| 
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
  