# Stock < ApplicationRecord
class Stock < ApplicationRecord

  belongs_to :variant
  belongs_to :user
  belongs_to :stockable, polymorphic: true

  def self.ransackable_attributes(auth_object = nil)
    attribute_names
  end

  def self.ransackable_associations(auth_object = nil)
    %w[stockable user variant]
  end

  def self.amount
    # NOTICE (lifehack) if we call from relation than we will get only relation data
    stocks = Stock.all.order(created_at: :asc)

    return 0 if stocks.empty?

    # s_qt = 0
    # stocks.each do |stock|
    #   qt = s_qt + stock.value if stock.move == '+'
    #   qt = s_qt - stock.value if stock.move == '-'
    #   s_qt = qt
    # end
    # s_qt
    stocks.map{|a| a.move+a.value.to_s}.map(&:to_i).sum
  end

  def self.plus
    # NOTICE (lifehack) if we call from relation than we will get only relation data
    stocks = Stock.all.order(created_at: :asc)
    plus_text = []
    stocks.each do |stock|
      text = [stock.document, stock.value.to_s].join(': ') if stock.move == '+'
      plus_text.push(text) if stock.move == '+'
    end
    plus_text.join(' ')
  end

  def self.minus
    # NOTICE (lifehack) if we call from relation than we will get only relation data
    stocks = Stock.all.order(created_at: :asc)
    minus_text = []
    stocks.each do |stock|
      text = [stock.document, stock.value.to_s].join(': ') if stock.move == '-'
      minus_text.push(text) if stock.move == '-'
    end
    minus_text.join(' ')
  end

  def document
    self.stockable.parent.model_name.human
  end

end
