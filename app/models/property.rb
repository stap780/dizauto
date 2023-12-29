class Property < ApplicationRecord
    has_many :props, -> { order(id: :asc) }
    has_many :products, through: :props
    has_many :characteristics, -> { order(:id) }, dependent: :destroy
    accepts_nested_attributes_for :characteristics, reject_if: ->(attributes){ attributes['title'].blank? }, allow_destroy: true
    validates :title, presence: true

    def self.ransackable_attributes(auth_object = nil)
        Property.attribute_names
    end

    def c_val(characteristic_id)
        self.characteristics.find_by_id(characteristic_id)
    end
end
