# frozen_string_literal: true

# OrderItem < ApplicationRecord
class OrderItem < ApplicationRecord
  include NormalizeDataWhiteSpace
  belongs_to :order
  belongs_to :variant
  audited associated_with: :order

  validates :quantity, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0}
  validates :price, presence: true, numericality: {greater_than_or_equal_to: 0}

  def self.ransackable_attributes(auth_object = nil)
    OrderItem.attribute_names
  end

end
