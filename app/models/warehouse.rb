class Warehouse < ApplicationRecord
  has_many :places
  has_many :products, through: :places

  before_save :normalize_data_white_space
  validates :title, presence: true
  validates :title, uniqueness: true

  def self.ransackable_attributes(auth_object = nil)
    Warehouse.attribute_names
  end

  private

  def normalize_data_white_space
    attributes.each do |key, value|
      self[key] = value.squish if value.respond_to?(:squish)
    end
  end
end
