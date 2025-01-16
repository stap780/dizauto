# Delivery < ApplicationRecord
class Delivery < ApplicationRecord
  belongs_to :order
  belongs_to :delivery_type

  validates :price, presence: true
end
