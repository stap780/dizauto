# IncaseItemStatus < ApplicationRecord
class IncaseItemStatus < ApplicationRecord
  include NormalizeDataWhiteSpace
  acts_as_list
  has_many :incase_items
  after_create_commit { broadcast_prepend_to 'incase_item_statuses' }
  after_update_commit { broadcast_replace_to 'incase_item_statuses' }
  after_destroy_commit { broadcast_remove_to 'incase_item_statuses' }
  validates :title, presence: true

  def self.ransackable_attributes(auth_object = nil)
    IncaseItemStatus.attribute_names
  end


end
