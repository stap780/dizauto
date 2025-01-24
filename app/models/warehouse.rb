# Warehouse < ApplicationRecord
class Warehouse < ApplicationRecord
  acts_as_list
  has_many :places, dependent: :destroy
  accepts_nested_attributes_for :places, allow_destroy: true, reject_if: :all_blank
  has_many :supplies
  has_many :placements

  before_save :normalize_data_white_space
  validates :title, presence: true
  validates :title, uniqueness: true
  after_create_commit { broadcast_prepend_to 'warehouses' }
  after_update_commit { broadcast_replace_to 'warehouses' }
  after_destroy_commit { broadcast_remove_to 'warehouses' }
  before_destroy :check_presence_in_products, prepend: true


  def self.ransackable_attributes(auth_object = nil)
    Warehouse.attribute_names
  end

  def self.ransackable_associations(auth_object = nil)
    %w[places supplies locations placements]
  end

  private

  def normalize_data_white_space
    attributes.each do |key, value|
      self[key] = value.squish if value.respond_to?(:squish)
    end
  end

  def check_presence_in_products
    if placements.count.positive?
      errors.add(:base, 'Cannot delete warehouse. You have placements with it.')
      throw(:abort)
    end
  end

end
