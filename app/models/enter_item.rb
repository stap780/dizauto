# EnterItem < ApplicationRecord
class EnterItem < ApplicationRecord
  include Stockable

  belongs_to :enter
  belongs_to :variant
  after_save_commit :set_stock

  private

  def set_stock
    if self.stock
      self.stock.update!(move: '+',value: self.quantity, user_id: User.current.id)
    else
      self.create_stock!(move: '+',value: self.quantity, user_id: User.current.id, variant_id: self.variant_id)
    end
  end
  
end
