class OrderStatus < ApplicationRecord
  has_many :orders
  validates :title, presence: true
  after_create_commit { broadcast_prepend_to "order_statuses" }
  after_update_commit { broadcast_replace_to "order_statuses" }
  after_destroy_commit { broadcast_remove_to "order_statuses" }
  before_save :normalize_data_white_space
  before_destroy :check_presence_in_orders, prepend: true


  def self.ransackable_attributes(auth_object = nil)
    OrderStatus.attribute_names
  end

  private

  def normalize_data_white_space
    attributes.each do |key, value|
      self[key] = value.squish if value.respond_to?(:squish)
    end
  end

  def check_presence_in_orders
    if orders.count > 0
      errors.add(:base, "Cannot delete warehouse. You have orders with it.")
      throw(:abort)
    end
  end

end
