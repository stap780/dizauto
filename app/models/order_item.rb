# frozen_string_literal: true

# OrderItem < ApplicationRecord
class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :variant
  audited associated_with: :order

  validates :quantity, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0}
  validates :price, presence: true, numericality: {greater_than_or_equal_to: 0}
  before_save :normalize_data_white_space

  def self.ransackable_attributes(auth_object = nil)
    OrderItem.attribute_names
  end

  private

  def normalize_data_white_space
    attributes.each do |key, value|
      self[key] = value.squish if value.respond_to?(:squish)
    end
  end

end
