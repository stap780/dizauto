# frozen_string_literal: true

# Order < ApplicationRecord
class Order < ApplicationRecord
  include AutomationProcess
  audited
  belongs_to :order_status
  belongs_to :payment_type
  # belongs_to :delivery_type
  belongs_to :client
  belongs_to :company, optional: true
  belongs_to :manager, class_name: 'User', foreign_key: 'manager_id', optional: true
  has_many :order_items, dependent: :destroy
  accepts_nested_attributes_for :order_items, allow_destroy: true
  has_many :shippings, dependent: :destroy
  accepts_nested_attributes_for :shippings, allow_destroy: true
  has_many :comments, as: :commentable, dependent: :destroy
  accepts_nested_attributes_for :comments, allow_destroy: true
  has_one :delivery, dependent: :destroy
  accepts_nested_attributes_for :delivery, allow_destroy: true
  has_one :delivery_type, through: :delivery

  after_create_commit { broadcast_prepend_to 'orders' }
  after_destroy_commit { broadcast_remove_to 'orders' }

  before_save :normalize_data_white_space

  def self.ransackable_attributes(auth_object = nil)
    Order.attribute_names
  end

  def self.ransackable_associations(auth_object = nil)
    %w[associated_audits audits order_items shippings delivery]
  end

  def total_sum
    return order_items.sum(:sum) unless delivery.price

    order_items.sum(:sum) + delivery.price
  end

  private

  def normalize_data_white_space
    attributes.each do |key, value|
      self[key] = value.squish if value.respond_to?(:squish)
    end
  end

end
