class SupplyItem < ApplicationRecord
  include Stockable
  audited associated_with: :supply
  
  belongs_to :supply
  belongs_to :product

  validates :quantity, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0}
  validates :price, presence: true, numericality: {greater_than_or_equal_to: 0}
  before_save :normalize_data_white_space

  after_commit :set_stock


  def self.ransackable_attributes(auth_object = nil)
    SupplyItem.attribute_names
  end

  private

  def set_stock
    if self.stock
      self.stock.update!(move: "+",value: self.quantity, user_id: User.current.id)
    else
      self.create_stock!(move: "+",value: self.quantity, user_id: User.current.id, product_id: self.product_id)
    end
  end

  def normalize_data_white_space
    attributes.each do |key, value|
      self[key] = value.squish if value.respond_to?(:squish)
    end
  end
end
