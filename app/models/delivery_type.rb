# frozen_string_literal: true

# DeliveryType < ApplicationRecord
class DeliveryType < ApplicationRecord
  include NormalizeDataWhiteSpace
  acts_as_list
  has_many :deliveries
  validates :title, presence: true
  after_create_commit { broadcast_append_to 'delivery_types' }
  after_update_commit { broadcast_replace_to 'delivery_types' }
  after_destroy_commit { broadcast_remove_to 'delivery_types' }
  before_destroy :check_destroy_ability, prepend: true


  def self.ransackable_attributes(auth_object = nil)
    DeliveryType.attribute_names
  end

  def title_price
    "#{title} - #{price}p"
  end

  def last?
    DeliveryType.all.count == 1
  end

  private

  def check_destroy_ability
    if last?
      errors.add(:base, 'Cannot delete last Delivery Type.')
    end
    if orders.count.positive?
      errors.add(:base, 'Cannot delete Delivery Type. You have orders with it.')
    end
    throw(:abort) if errors.present?
  end

end
