class Prodprop < ApplicationRecord
    belongs_to :product
    belongs_to :property
    belongs_to :characteristic

    validates :product_id, presence: true
    validates :property_id, presence: true
    validates :characteristic_id, presence: true
    
end
