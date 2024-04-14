class Drop::Incase < Liquid::Drop
  def initialize(incase)
    @incase = incase
  end

  def do_work # this is for check condition true/false
    "do_work"
  end

  def id
    @incase.id
  end

  def region
    @incase.region
  end

  def strah
    # @incase.strah.present? ? @incase.strah.short_title : ''
    @incase.strah.present? ? @incase.strah.attributes : []
  end

  def stoanumber
    @incase.stoanumber
  end

  def unumber
    @incase.unumber
  end

  def unumber_uniq?
    Incase.where(unumber: @incase.unumber).size == 1
  end

  def unumber_not_uniq?
    !(Incase.where(unumber: @incase.unumber).size == 1)
  end

  def company
    # @incase.company.present? ? @incase.company.short_title : ''
    @incase.company.present? ? @incase.company.attributes : []
  end

  def company_clients
    @incase.company.present? ? @incase.company.clients.map { |cl| cl.attributes } : []
  end

  def company_comment
    # @incase.company.present? ? @incase.company.short_title : ''
    (@incase.company.present? && @incase.company.comments.present?) ? @incase.company.comments.first.body : ""
  end

  def carnumber
    @incase.carnumber
  end

  def date
    @incase.date
  end

  def modelauto
    @incase.modelauto
  end

  def totalsum
    @incase.totalsum.to_i
  end

  def status
    @incase.incase_status.present? ? @incase.incase_status.title : ""
  end

  def tip
    @incase.incase_tip_id.present? ? @incase.incase_tip.title : ""
  end

  def items
    # @incase.incase_items.present? ? @incase.incase_items.map { |li| li.attributes } : []

    @incase.incase_items.present? ? @incase.incase_items.map { |li| 
      {
        "id" => li.id,
        "title" => li.title, 
        "quantity" => li.quantity, 
        "katnumber" => li.katnumber,
        "price" => li.price, 
        "sum" => li.sum,
        "status" => li.incase_item_status.title,
        "have_supply?" => li.product.present? && li.product.supplies.present? ? true : false
      }
    } : []
  end

  def items_statuses
    @incase.incase_items.map { |i_i| i_i.incase_item_status.title }
  end
end
