class Client < ApplicationRecord
    has_many :client_companies
    has_many :companies, through: :client_companies
    has_many :orders
    validates :name, presence: true
    validates :email, presence: true
    validates :email, uniqueness: true

    before_save :normalize_data_white_space
    before_destroy :check_presence_in_orders!, prepend: true

    def full_name
        [name, surname, email].join(' ')
    end

    def self.ransackable_attributes(auth_object = nil)
        Client.attribute_names
    end

    private


    def normalize_data_white_space
        self.attributes.each do |key, value|
            self[key] = value.squish if value.respond_to?("squish")
        end
    end

    def check_presence_in_orders!
        if self.orders.count > 0
            errors.add(:base, 'Cannot delete client. You have items with it.')
            throw(:abort)
        end
    end

end
