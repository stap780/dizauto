class SupplyStatus < ApplicationRecord
  include NormalizeDataWhiteSpace
  acts_as_list
  has_many :supplies

  before_destroy :check_presence_in_supplies, prepend: true

  after_create_commit { broadcast_prepend_to "supply_statuses" }
  after_update_commit { broadcast_replace_to "supply_statuses" }
  after_destroy_commit { broadcast_remove_to "supply_statuses" }
  validates :title, presence: true

  def self.ransackable_attributes(auth_object = nil)
    SupplyStatus.attribute_names
  end

  private

  def check_presence_in_supplies
    if supplies.count > 0
      errors.add(:base, "Cannot delete Status. You have Supplies with it.")
      throw(:abort)
    end
  end

end
