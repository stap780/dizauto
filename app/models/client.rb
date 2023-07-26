class Client < ApplicationRecord
    has_many :client_companies
    has_many :companies, through: :client_companies

    validates :name, presence: true

    before_save :normalize_data_white_space



    def self.ransackable_attributes(auth_object = nil)
        Client.attribute_names
    end

    private


    def normalize_data_white_space
        self.attributes.each do |key, value|
            self[key] = value.squish if value.respond_to?("squish")
        end
    end

end
