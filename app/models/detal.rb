class Detal < ApplicationRecord

    has_many :props
    has_many :properties, through: :props
    accepts_nested_attributes_for :props, allow_destroy: true
    has_rich_text :description

    validates :sku, presence: true
    validates :title, presence: true

    before_save :normalize_data_white_space

    def self.ransackable_attributes(auth_object = nil)
        Detal.attribute_names
    end


    private

    def normalize_data_white_space
        self.attributes.each do |key, value|
            self[key] = value.squish if value.respond_to?("squish")
        end
    end

end
