class Company < ApplicationRecord
    
    has_many :incases

    validates :title, presence: true
    validates :short_title, presence: true
    validates :inn, presence: true
    validates :inn, uniqueness: true
    scope :strah, -> { where(tip: 'страховая') }
    scope :standart, -> { where(tip: 'стандартная') }

    Company::TIP = ['стандартная', 'страховая'].freeze

    def self.ransackable_attributes(auth_object = nil)
        Company.attribute_names
    end

end
