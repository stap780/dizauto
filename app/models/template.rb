class Template < ApplicationRecord

    validates :title, presence: true
    validates :content, presence: true

    before_save :normalize_data_white_space

    RECEIVER = [['Клиент','client'],['Менеджер','manager']].freeze

    def self.ransackable_attributes(auth_object = nil)
        Template.attribute_names
    end

    private


    def normalize_data_white_space
        self.attributes.each do |key, value|
            self[key] = value.squish if value.respond_to?("squish")
        end
    end


end
