class SupplyItem < ApplicationRecord
  include NormalizeDataWhiteSpace
  include Stockable
  audited associated_with: :supply
  
  belongs_to :supply
  belongs_to :variant

  validates :quantity, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0}
  validates :price, presence: true, numericality: {greater_than_or_equal_to: 0}

  after_save_commit :set_stock


  def self.ransackable_attributes(auth_object = nil)
    SupplyItem.attribute_names
  end

  private

  def set_stock
    if self.stock
      self.stock.update!(move: "+",value: self.quantity, user_id: User.current.id)
    else
      self.create_stock!(move: "+",value: self.quantity, user_id: User.current.id, variant_id: self.variant_id)
    end
  end
  
end
