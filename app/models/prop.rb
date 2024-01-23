class Prop < ApplicationRecord
    belongs_to :product, optional: true # это убирает проверку presence: true , которая стоит по дефолту
    belongs_to :property
    belongs_to :characteristic
    belongs_to :detal, optional: true # это убирает проверку presence: true , которая стоит по дефолту

    default_scope -> { order(id: :asc) }

    validates :characteristic_id, uniqueness: {scope: [:property,:product,:detal] } # we use 3 model (property,detal,product) because prop is a between table
    validates :characteristic_id, uniqueness: {scope: [:property,:detal,:product] } # we use 3 model (property,detal,product) because prop is a between table

    
end
