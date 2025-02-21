class Characteristic < ApplicationRecord
  belongs_to :property
  has_many :props, -> { order(id: :asc) }
  has_many :products, through: :props
  validates :title, presence: true
  before_destroy :check_presence_in_props

  def self.ransackable_attributes(auth_object = nil)
    Characteristic.attribute_names
  end

  private

  def check_presence_in_props
    if props.count > 0
      errors.add(:base, 'Cannot delete characteristic. You have items with it')
      throw(:abort)
    end
  end
end
