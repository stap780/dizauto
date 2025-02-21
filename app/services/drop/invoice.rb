# Drop::Invoice < Liquid::Drop
class Drop::Invoice < Liquid::Drop
  
  def initialize(invoice)
    @invoice = invoice
  end

  # this is for check condition true/false
  def do_work
    'do_work'
  end

  def id
    @invoice.id
  end

  def number
    @invoice.number
  end

  def status
    @invoice.invoice_status&.title.to_s
  end

  def client
    @invoice.client.present? ? @invoice.client.attributes : []
  end

  def company
    @invoice.company.present? ? @invoice.company.attributes : []
  end

  def totalsum
    return 0 unless @invoice.invoice_items.present?

    @invoice.invoice_items.sum(:sum)
  end

  def items
    # @invoice.invoice_items.map(&:attributes)
    @invoice.invoice_items.map { |li|
      {
        'id'=>li.id,
        'title'=>li.variant.product.title,
        'price'=>li.price, 
        'discount'=>li.discount, 
        'sum'=> li.sum,
        'quantity'=>li.quantity,
        'vat'=>li.vat
      }
    }
  end

  def seller
    @invoice.seller.present? ? @invoice.seller.attributes : []
  end

end
