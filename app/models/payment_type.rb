# frozen_string_literal: true

# PaymentType < ApplicationRecord
class PaymentType < ApplicationRecord
  include NormalizeDataWhiteSpace
  acts_as_list

  has_many :orders
  validates :title, presence: true
  after_create_commit { broadcast_append_to 'payment_types' }
  after_update_commit { broadcast_replace_to 'payment_types' }
  after_destroy_commit { broadcast_remove_to 'payment_types' }
  before_destroy :check_destroy_ability, prepend: true


  def self.ransackable_attributes(auth_object = nil)
    PaymentType.attribute_names
  end

  def last?
    PaymentType.all.count == 1
  end

  private

  def check_destroy_ability
    if last?
      errors.add(:base, 'Cannot delete last Payment Type.')
    end
    if orders.count.positive?
      errors.add(:base, 'Cannot delete warehouse. You have orders with it.')
    end
    throw(:abort) if errors.present?
  end

end
