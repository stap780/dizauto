class ReturnStatus < ApplicationRecord
  include NormalizeDataWhiteSpace
  acts_as_list
  has_many :returns
  after_create_commit { broadcast_prepend_to "return_statuses" }
  after_update_commit { broadcast_replace_to "return_statuses" }
  after_destroy_commit { broadcast_remove_to "return_statuses" }
  before_destroy :check_presence_in_returns, prepend: true

  validates :title, presence: true

  def self.ransackable_attributes(auth_object = nil)
      ReturnStatus.attribute_names
  end

  private

  def check_presence_in_returns
      if returns.count > 0
        errors.add(:base, "Cannot delete Return Status. You have returns with it.")
        throw(:abort)
      end
  end

end
