class Company < ApplicationRecord
    audited
    has_many :incases
    has_many :client_companies
    has_many :clients, through: :client_companies
	accepts_nested_attributes_for :client_companies, allow_destroy: true
    has_many :comments, as: :commentable
    accepts_nested_attributes_for :comments, allow_destroy: true

    validates :title, presence: true
    validates :short_title, presence: true
    validates :inn, presence: true
    validates :inn, uniqueness: true
    validates :client_companies, presence: true

    before_save :normalize_data_white_space

    scope :strah, -> { where(tip: 'страховая') }
    scope :standart, -> { where(tip: 'стандартная') }

    Company::TIP = ['стандартная', 'страховая'].freeze

    def self.ransackable_attributes(auth_object = nil)
        Company.attribute_names
    end

    def self.ransackable_associations(auth_object = nil)
        ["audits", "incases", "client_companies"]
    end

    def emails
        self.clients.pluck(:email).join
    end

    def main_email
        # need create
        self.clients.first.email
    end

    private

    def normalize_data_white_space
        self.attributes.each do |key, value|
            self[key] = value.squish if value.respond_to?("squish")
        end
    end

end
