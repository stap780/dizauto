class IncaseTip < ApplicationRecord
  include NormalizeDataWhiteSpace
  acts_as_list
  has_many :incases

  before_destroy :check_presence_in_incases, prepend: true

  after_create_commit { broadcast_prepend_to "incase_tips" }
  after_update_commit { broadcast_replace_to "incase_tips" }
  after_destroy_commit { broadcast_remove_to "incase_tips" }

  validates :title, presence: true

  def self.ransackable_attributes(auth_object = nil)
    IncaseTip.attribute_names
  end

  private

  def check_presence_in_incases
    if incase.count > 0
      errors.add(:base, "Cannot delete incase_statuses. You have incase with it.")
      throw(:abort)
    end
  end

end
