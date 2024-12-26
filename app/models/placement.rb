class Placement < ApplicationRecord
  belongs_to :warehouse
  has_many :locations, dependent: :destroy
  accepts_nested_attributes_for :locations, allow_destroy: true
  
  validates :locations, presence: true

  def self.ransackable_attributes(auth_object = nil)
    Placement.attribute_names
  end

  def self.ransackable_associations(auth_object = nil)
    ["locations", "warehouse"]
  end

end
