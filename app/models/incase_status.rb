# IncaseStatus < ApplicationRecord
class IncaseStatus < ApplicationRecord
  include NormalizeDataWhiteSpace
  acts_as_list
  has_many :incases

  before_destroy :check_presence_in_incases, prepend: true

  after_create_commit { broadcast_prepend_to 'incase_statuses' }
  after_update_commit { broadcast_replace_to 'incase_statuses' }
  after_destroy_commit { broadcast_remove_to 'incase_statuses' }

  validates :title, presence: true

  def self.ransackable_attributes(auth_object = nil)
    attribute_names
  end

  private

  def check_presence_in_incases
    return unless incases.count > 0

    errors.add(:base, I18n.t('helpers.label.incase_status.check_presence_in_incases'))
    throw(:abort)
  end

end
