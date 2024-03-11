class SupplyItem < ApplicationRecord

    belongs_to :supply
    belongs_to :warehouse
    audited associated_with: :supply

	validates :product_id, presence: true
    validates :quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
    validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
    before_save :normalize_data_white_space

    def self.ransackable_attributes(auth_object = nil)
        SupplyItem.attribute_names
    end

    private

    def normalize_data_white_space
        self.attributes.each do |key, value|
            self[key] = value.squish if value.respond_to?("squish")
        end
    end

end
