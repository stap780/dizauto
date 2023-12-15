class IncaseTip < ApplicationRecord
    acts_as_list
    has_many :incases

    before_save :normalize_data_white_space
	validates :title, presence: true
    validates :position, uniqueness: true


    def self.ransackable_attributes(auth_object = nil)
        IncaseTip.attribute_names
    end


    private

    def normalize_data_white_space
        self.attributes.each do |key, value|
            self[key] = value.squish if value.respond_to?("squish")
        end
    end

end
