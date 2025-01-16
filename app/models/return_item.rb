class ReturnItem < ApplicationRecord
  include Stockable

  belongs_to :variant
  belongs_to :return
  after_save_commit :set_stock
  validates :quantity, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0}
  validates :price, presence: true, numericality: {greater_than_or_equal_to: 0}

  private

  def set_stock
    if self.stock
      self.stock.update!(move: "+",value: self.quantity, user_id: User.current.id)
    else
      self.create_stock!(move: "+",value: self.quantity, user_id: User.current.id, variant_id: self.variant_id)
    end
  end
  
end
