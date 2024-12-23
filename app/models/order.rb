# frozen_string_literal: true

# Order < ApplicationRecord
class Order < ApplicationRecord
  include AutomationProcess
  audited
  belongs_to :order_status
  belongs_to :payment_type
  belongs_to :delivery_type
  belongs_to :client
  belongs_to :company, optional: true
  belongs_to :manager, class_name: 'User', foreign_key: 'manager_id'
  has_many :order_items, dependent: :destroy
  accepts_nested_attributes_for :order_items, allow_destroy: true
  has_many :comments, as: :commentable, dependent: :destroy
  accepts_nested_attributes_for :comments, allow_destroy: true

  after_destroy_commit { broadcast_remove_to 'orders' }

  before_save :normalize_data_white_space
  # validates :order_items, presence: true

  def self.ransackable_attributes(auth_object = nil)
    Order.attribute_names
  end

  def self.ransackable_associations(auth_object = nil)
    %w[associated_audits audits order_items]
  end

  private

  def normalize_data_white_space
    attributes.each do |key, value|
      self[key] = value.squish if value.respond_to?(:squish)
    end
  end

end
