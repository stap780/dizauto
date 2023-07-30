class IncaseItem < ApplicationRecord

    belongs_to :incase
    belongs_to :incase_item_status
    audited associated_with: :incase

    validates :title, :presence => true
    before_save :normalize_data_white_space

    # IncaseItem::STATUS = ['Да',
    #                     'Долг',
    #                     'В работе',
    #                     'Нет (Отсутствовала)',
    #                     'Нет (ДРМ)',
    #                     'Нет (Срез)',
    #                     'Нет (Стекло)',
    #                     'Нет',
    #                     'Нет (МО)',
    #                     'Не запрашиваем'].freeze

    def self.ransackable_attributes(auth_object = nil)
        IncaseItem.attribute_names
    end

    private

    def normalize_data_white_space
        self.attributes.each do |key, value|
            self[key] = value.squish if value.respond_to?("squish")
        end
    end
    
end
