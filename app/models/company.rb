class Company < ApplicationRecord

    validates :title, presence: true
    validates :inn, presence: true


    def self.ransackable_attributes(auth_object = nil)
        Company.attribute_names
    end

end
