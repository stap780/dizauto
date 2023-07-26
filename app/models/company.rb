class Company < ApplicationRecord
    audited
    has_many :incases
    has_many :client_companies
    has_many :companies, through: :client_companies

    validates :title, presence: true
    validates :short_title, presence: true
    validates :inn, presence: true
    validates :inn, uniqueness: true
    scope :strah, -> { where(tip: 'страховая') }
    scope :standart, -> { where(tip: 'стандартная') }

    Company::TIP = ['стандартная', 'страховая'].freeze

    def self.ransackable_associations(auth_object = nil)
        ["audits", "incases"]
    end

    def self.ransackable_attributes(auth_object = nil)
        Company.attribute_names
    end

end
