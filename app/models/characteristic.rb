class Characteristic < ApplicationRecord
    belongs_to :property
    has_many :props, -> { order(id: :asc) }
    has_many :products, through: :props
    validates :title, presence: true

    def self.ransackable_attributes(auth_object = nil)
      Characteristic.attribute_names
    end

end
