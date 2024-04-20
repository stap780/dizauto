class Order < ApplicationRecord
  audited
  belongs_to :order_status
  belongs_to :payment_type
  belongs_to :delivery_type
  belongs_to :client
  belongs_to :company, optional: true
  belongs_to :manager, class_name: "User", foreign_key: "manager_id"
  has_many :order_items, dependent: :destroy
  accepts_nested_attributes_for :order_items, allow_destroy: true
  after_destroy_commit { broadcast_remove_to "orders" }

  # validates :order_items, presence: true

  before_save :normalize_data_white_space

  def self.ransackable_attributes(auth_object = nil)
    Order.attribute_names
  end

  private

  def normalize_data_white_space
    attributes.each do |key, value|
      self[key] = value.squish if value.respond_to?(:squish)
    end
  end

end
