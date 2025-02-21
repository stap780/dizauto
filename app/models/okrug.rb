class Okrug < ApplicationRecord
  include NormalizeDataWhiteSpace
  acts_as_list

  has_many :companies
  validates :title, presence: true
  validates :title, uniqueness: true
  after_create_commit { broadcast_prepend_to "okrugs" }
  after_update_commit { broadcast_replace_to "okrugs" }
  after_destroy_commit { broadcast_remove_to "okrugs" }

  def self.ransackable_attributes(auth_object = nil)
    Okrug.attribute_names
  end

end
