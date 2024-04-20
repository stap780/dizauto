class Drop::Invoice < Liquid::Drop
    def initialize(invoice)
      @invoice = invoice
    end
  
    def do_work # this is for check condition true/false
      "do_work"
    end
  
    def id
      @invoice.id
    end
    def number
      @invoice.number
    end
    def status
        @invoice.invoice_status.present? ? @invoice.invoice_status.title : ""
    end
  
    def client
      @invoice.client.present? ? @invoice.client.attributes : []
    end
  
    def company
      @invoice.company.present? ? @invoice.company.attributes : []
    end
  
    def totalsum
      @invoice.invoice_items.present? ?  @invoice.invoice_items.sum(:sum) : ''
    end
  
    def items
      #li.attributes 
      @invoice.invoice_items.present? ? @invoice.invoice_items.map { |li| 
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
  