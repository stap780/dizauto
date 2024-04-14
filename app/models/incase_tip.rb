class IncaseTip < ApplicationRecord
  acts_as_list
  has_many :incases

  before_save :normalize_data_white_space
  before_destroy :check_presence_in_incases, prepend: true

  after_create_commit { broadcast_prepend_to "incase_tips" }
  after_update_commit { broadcast_replace_to "incase_tips" }
  after_destroy_commit { broadcast_remove_to "incase_tips" }

  validates :title, presence: true

  def self.ransackable_attributes(auth_object = nil)
    IncaseTip.attribute_names
  end

  private

  def normalize_data_white_space
    attributes.each do |key, value|
      self[key] = value.squish if value.respond_to?(:squish)
    end
  end

  def check_presence_in_incases
    if incase.count > 0
      errors.add(:base, "Cannot delete incase_statuses. You have incase with it.")
      throw(:abort)
    end
  end

end
