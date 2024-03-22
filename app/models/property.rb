class Property < ApplicationRecord
  has_many :props, -> { order(id: :asc) }
  has_many :products, through: :props
  has_many :characteristics, -> { order(:id) }, dependent: :destroy
  accepts_nested_attributes_for :characteristics, reject_if: ->(attributes) { attributes["title"].blank? }, allow_destroy: true
  validates :title, presence: true
  validates :title, uniqueness: true
  before_destroy :check_presence_in_props!, prepend: true

  def self.ransackable_attributes(auth_object = nil)
    Property.attribute_names
  end

  def c_val(characteristic_id)
    characteristics.find_by_id(characteristic_id)
  end

  private

  def check_presence_in_props!
    if props.count > 0
      errors.add(:base, "Cannot delete property. You have items with it.")
      throw(:abort)
    end
  end
end
