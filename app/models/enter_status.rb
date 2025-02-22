# EnterStatus < ApplicationRecord
class EnterStatus < ApplicationRecord
  include NormalizeDataWhiteSpace
  acts_as_list
  has_many :enters

  before_destroy :check_presence_in_enters, prepend: true

  after_create_commit { broadcast_prepend_to 'enter_statuses' }
  after_update_commit { broadcast_replace_to 'enter_statuses' }
  after_destroy_commit { broadcast_remove_to 'enter_statuses' }
  validates :title, presence: true

  def self.ransackable_attributes(auth_object = nil)
    EnterStatus.attribute_names
  end

  private

  def check_presence_in_enters
    if enters.count.positive?
      errors.add(:base, 'Cannot delete Enter Status. You have Enters with it.')
      throw(:abort)
    end
  end

end
