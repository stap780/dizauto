class Okrug < ApplicationRecord
  acts_as_list

  has_many :companies
  before_save :normalize_data_white_space
  validates :title, presence: true
  validates :title, uniqueness: true
  after_create_commit { broadcast_prepend_to "okrugs" }
  after_update_commit { broadcast_replace_to "okrugs" }
  after_destroy_commit { broadcast_remove_to "okrugs" }

  def self.ransackable_attributes(auth_object = nil)
    Okrug.attribute_names
  end

  private

  def normalize_data_white_space
    attributes.each do |key, value|
      self[key] = value.squish if value.respond_to?(:squish)
    end
  end
end
