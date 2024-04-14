class PaymentType < ApplicationRecord
  acts_as_list

  has_many :orders
  validates :title, presence: true
  before_save :normalize_data_white_space
  after_create_commit { broadcast_prepend_to "payment_types" }
  after_update_commit { broadcast_replace_to "payment_types" }
  after_destroy_commit { broadcast_remove_to "payment_types" }
  before_destroy :check_presence_in_orders, prepend: true


  def self.ransackable_attributes(auth_object = nil)
    PaymentType.attribute_names
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
