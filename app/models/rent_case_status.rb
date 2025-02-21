class RentCaseStatus < ApplicationRecord
  include NormalizeDataWhiteSpace
  acts_as_list
  has_many :incases
  after_create_commit { broadcast_prepend_to "rent_case_statuses" }
  after_update_commit { broadcast_replace_to "rent_case_statuses" }
  after_destroy_commit { broadcast_remove_to "rent_case_statuses" }

  validates :title, presence: true

  def self.ransackable_attributes(auth_object = nil)
    RentCaseStatus.attribute_names
  end

end
