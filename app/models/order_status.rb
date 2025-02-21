class OrderStatus < ApplicationRecord
  include NormalizeDataWhiteSpace
  acts_as_list
  has_many :orders
  after_create_commit { broadcast_append_to 'order_statuses' }
  after_update_commit { broadcast_replace_to 'order_statuses' }
  after_destroy_commit { broadcast_remove_to 'order_statuses' }
  before_destroy :check_destroy_ability, prepend: true

  validates :title, presence: true

  def self.ransackable_attributes(auth_object = nil)
    OrderStatus.attribute_names
  end

  def last_order_status?
    OrderStatus.all.count == 1
  end

  private

  def check_destroy_ability
    if last_order_status?
      errors.add(:base, 'Cannot delete last Order Status.')
    end
    if orders.count.positive?
      errors.add(:base, 'Cannot delete Order Status. You have orders with it.')
    end
    throw(:abort) if errors.present?
  end

end
