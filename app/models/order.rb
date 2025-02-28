# frozen_string_literal: true

# Order < ApplicationRecord
class Order < ApplicationRecord
  include NormalizeDataWhiteSpace
  include AutomationProcess
  audited
  belongs_to :order_status
  belongs_to :payment_type
  # belongs_to :delivery_type
  belongs_to :client
  belongs_to :company, optional: true
  belongs_to :manager, class_name: 'User', foreign_key: 'manager_id', optional: true
  belongs_to :seller, class_name: 'Company', foreign_key: 'seller_id'
  has_many :order_items, dependent: :destroy
  accepts_nested_attributes_for :order_items, allow_destroy: true
  has_many :shippings, dependent: :destroy
  accepts_nested_attributes_for :shippings, allow_destroy: true
  has_many :comments, as: :commentable, dependent: :destroy
  accepts_nested_attributes_for :comments, allow_destroy: true
  has_one :delivery, dependent: :destroy
  accepts_nested_attributes_for :delivery, allow_destroy: true
  has_one :delivery_type, through: :delivery

  after_create_commit { broadcast_prepend_to 'orders_page1' }
  after_update_commit { broadcast_replace_to 'orders' }
  after_destroy_commit { broadcast_remove_to 'orders' }
  after_destroy_commit { broadcast_remove_to 'orders_page1' }

  attribute :total_sum

  def self.ransackable_attributes(auth_object = nil)
    attribute_names
  end

  def self.ransackable_associations(auth_object = nil)
    %w[associated_audits audits order_items shippings delivery]
  end

  def subtotal_sum
    sub_total = 0
    order_items.each do |item|
      vat = (100 + item.vat) / 100.0
      sub_total += item.quantity * item.price / vat
    end
    result = 0
    if delivery
      d_cost = delivery.price / ((100 + delivery.vat) / 100)
      result = sub_total + d_cost
    else
      result = sub_total
    end
    result.round(2)
  end

  def total_sum
    return order_items.sum(:sum) unless delivery.price

    order_items.sum(:sum) + delivery.price
  end

  def self.total_sum 
    # (lifehack) if we call from relation than we will get only relation data
    orders = Order.all.order(created_at: :asc)
    sum = [0]
    orders.each do |order|
      sum << order.total_sum
    end
    sum.sum
  end


end
