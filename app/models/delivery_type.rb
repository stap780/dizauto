class DeliveryType < ApplicationRecord
    has_many :orders
    validates :title, presence: true
    before_save :normalize_data_white_space

    def self.ransackable_attributes(auth_object = nil)
        Delivery.attribute_names
    end

    def title_price
        self.title.to_s+" - "+self.price.to_s+"р"
    end

    private

    def normalize_data_white_space
        self.attributes.each do |key, value|
            self[key] = value.squish if value.respond_to?("squish")
        end
    end

end
