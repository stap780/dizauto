class RentCaseStatus < ApplicationRecord
  acts_as_list
  has_many :incases
  after_create_commit { broadcast_prepend_to "rent_case_statuses" }
  after_update_commit { broadcast_replace_to "rent_case_statuses" }
  after_destroy_commit { broadcast_remove_to "rent_case_statuses" }
  before_save :normalize_data_white_space

  validates :title, presence: true

  def self.ransackable_attributes(auth_object = nil)
    RentCaseStatus.attribute_names
  end

  private

  def normalize_data_white_space
    attributes.each do |key, value|
      self[key] = value.squish if value.respond_to?(:squish)
    end
  end
  
end
