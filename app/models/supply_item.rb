class SupplyItem < ApplicationRecord

    belongs_to :supply
    belongs_to :warehouse
    audited associated_with: :supply

    validates :warehouse_id, presence: true
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
