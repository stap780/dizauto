class Stock < ApplicationRecord

  belongs_to :product
  belongs_to :user
  belongs_to :stockable, polymorphic: true
  # validates :product, uniqueness: {scope: [:stockable_id, :stockable_type]}


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

end
