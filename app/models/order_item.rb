class OrderItem < ApplicationRecord
    belongs_to :order
    belongs_to :product

    # validates :order_id, presence: true
    validates :product_id, presence: true
    validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
    validates :price, presence: true, presence: true, numericality: { greater_than: 0 }
    before_save :normalize_data_white_space

    def self.ransackable_attributes(auth_object = nil)
        OrderItem.attribute_names
    end


    private


    def normalize_data_white_space
        self.attributes.each do |key, value|
            self[key] = value.squish if value.respond_to?("squish")
        end
    end


end
