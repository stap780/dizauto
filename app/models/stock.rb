class Stock < ApplicationRecord

  belongs_to :variant
  belongs_to :user
  belongs_to :stockable, polymorphic: true
  # validates :variant, uniqueness: {scope: [:stockable_id, :stockable_type]}

  def self.ransackable_attributes(auth_object = nil)
    Stock.attribute_names
  end

  def self.ransackable_associations(auth_object = nil)
    ["stockable", "user", "variant"]
  end

  def self.amount
    stocks = Stock.all.order(created_at: :asc) # if we call from relation than it have only relation stocks (for example from Product)
    s_qt = 0
    stocks.each do |stock|
      qt = s_qt + stock.value if stock.move == "+"
      qt = s_qt - stock.value if stock.move == "-"
      s_qt = qt
    end
    s_qt
  end

  def self.plus
    stocks = Stock.all.order(created_at: :asc) # if we call from relation than it have only relation stocks (for example from Product)
    plus_text = []
    stocks.each do |stock|
      text = [stock.document, stock.value.to_s].join(': ') if stock.move == "+"
      plus_text.push(text) if stock.move == "+"
    end
    plus_text.join(' ')
  end

  def self.minus
    stocks = Stock.all.order(created_at: :asc) # if we call from relation than it have only relation stocks (for example from Product)
    minus_text = []
    stocks.each do |stock|
      text = [stock.document, stock.value.to_s].join(': ') if stock.move == "-"
      minus_text.push(text) if stock.move == "-"
    end
    minus_text.join(' ')
  end

  def document
    self.stockable.parent.model_name.human
  end



end
