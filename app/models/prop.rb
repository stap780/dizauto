class Prop < ApplicationRecord
    belongs_to :product, optional: true # это убирает проверку presence: true , которая стоит по дефолту
    belongs_to :property
    belongs_to :characteristic
    belongs_to :detal, optional: true

    default_scope -> { order(id: :asc) }

    validates :property_id, presence: true
    validates :characteristic_id, presence: true
    
end
