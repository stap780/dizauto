class OrderStatus < ApplicationRecord
  has_many :orders
  validates :title, presence: true
  before_save :normalize_data_white_space

  def self.ransackable_attributes(auth_object = nil)
    OrderStatus.attribute_names
  end

  private

  def normalize_data_white_space
    attributes.each do |key, value|
      self[key] = value.squish if value.respond_to?(:squish)
    end
  end
end
