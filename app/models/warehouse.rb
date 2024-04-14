class Warehouse < ApplicationRecord
  acts_as_list
  has_many :places
  has_many :products, through: :places

  before_save :normalize_data_white_space
  validates :title, presence: true
  validates :title, uniqueness: true
  after_create_commit { broadcast_prepend_to "warehouses" }
  after_update_commit { broadcast_replace_to "warehouses" }
  after_destroy_commit { broadcast_remove_to "warehouses" }
  before_destroy :check_presence_in_products, prepend: true


  def self.ransackable_attributes(auth_object = nil)
    Warehouse.attribute_names
  end

  private

  def normalize_data_white_space
    attributes.each do |key, value|
      self[key] = value.squish if value.respond_to?(:squish)
    end
  end

  def check_presence_in_products
    if products.count > 0
      errors.add(:base, "Cannot delete warehouse. You have products with it.")
      throw(:abort)
    end
  end

end
