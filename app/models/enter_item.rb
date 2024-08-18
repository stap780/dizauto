class EnterItem < ApplicationRecord
  include Stockable

  belongs_to :enter
  belongs_to :product
  after_commit :set_stock

  private

  def set_stock
    if self.stock
      self.stock.update!(move: "+",value: self.quantity, user_id: User.current.id)
    else
      self.create_stock!(move: "+",value: self.quantity, user_id: User.current.id, product_id: self.product_id)
    end
  end
  
end
