class LineItem < ApplicationRecord

    belongs_to :incase
    validates :title, :presence => true
    before_save :normalize_data_white_space

    LineItem::STATUS = ['Да',
                        'Долг',
                        'В работе',
                        'Нет (Отсутствовала)',
                        'Нет (ДРМ)',
                        'Нет (Срез)',
                        'Нет (Стекло)',
                        'Нет',
                        'Нет (МО)',
                        'Не запрашиваем'].freeze

    def self.ransackable_attributes(auth_object = nil)
        LineItem.attribute_names
    end

    private

    def normalize_data_white_space
        self.attributes.each do |key, value|
            self[key] = value.squish if value.respond_to?("squish")
        end
    end
    
end
