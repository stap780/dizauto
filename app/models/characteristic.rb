class Characteristic < ApplicationRecord
    belongs_to :property
    has_many :prodprops, -> { order(id: :asc) }
    has_many :products, through: :prodprops

    def self.ransackable_attributes(auth_object = nil)
      Characteristic.attribute_names
    end

end
