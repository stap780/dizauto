#Drop::Supply < Liquid::Drop
class Drop::Supply < Liquid::Drop
  def initialize(supply)
    @supply = supply
  end

  def do_work 
    # this is for check condition true/false
    'do_work'
  end

  def id
    @supply.id
  end

  def title
    @supply.title
  end
  def number
    @supply.number
  end

  def in_date
    @supply.in_date
  end

  def status
    @supply.supply_status.present? ? @supply.supply_status.title : ''
  end

  def company
    @supply.company.present? ? @supply.company.attributes : []
  end

  def manager
    @supply.manager.present? ? @supply.manager.attributes : []
  end


  def totalsum
    @supply.supply_items.present? ? @supply.supply_items.sum(:sum) : ''
  end

  def items
    #li.attributes 
    @supply.supply_items.present? ? @supply.supply_items.map { |li| 
      {
        "id"=>li.id,
        "title"=>li.product.title,
        "warehouse" => li.warehouse.title,
        "price"=>li.price, 
        "sum"=> li.sum,
        "quantity"=>li.quantity,
        "vat"=>li.vat
      }
    } : []
  end

end
