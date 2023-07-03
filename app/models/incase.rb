class Incase < ApplicationRecord
    audited
    belongs_to :company
    belongs_to :strah, class_name: "Company", foreign_key: "strah_id"
    has_many   :line_items, dependent: :destroy
	accepts_nested_attributes_for :line_items, allow_destroy: true, :reject_if => :all_blank #, reject_if: proc { |attributes| attributes['здесь пишем атрибут из line_items'].blank? }
    has_associated_audits
    
    before_save :normalize_data_white_space

	validates :date, presence: true
	validates :unumber, presence: true
    validates :unumber, uniqueness: true


    Incase::REGION = ['МСК', 'СПБ'].freeze
    Incase::STATUS = [  'Да',
                        'Да (кроме отсутствовавших)',
                        'Да (кроме стекла)',
                        'Да (кроме отсутствовавших и стекла)',
                        'Нет',
                        'Нет (ДРМ)',
                        'Нет (Срез)',
                        'Нет (Стекло)',
                        'Нет з/ч',
                        'Нет (область)',
                        'Долг',
                        'Частично',
                        'Не ездили',
                        'Да (кроме не запрашивать)',
                        'Не запрашиваем'
                    ].freeze
    Incase::TIP = ['Просрочен','Перепроверить','Тотал','Не согласовано'].freeze
    
    def self.ransackable_attributes(auth_object = nil)
        Incase.attribute_names
    end

    def self.import_attributes
        our_fields = []
        Incase.attribute_names.each do |fi| 
            # fi = 'company' if fi == 'company_id'
            # fi = 'strah' if fi == 'strah_id'
            our_fields.push(fi) if fi != 'id' && fi != 'created_at' && fi != 'updated_at' && fi != 'status' && fi != 'tip'
        end
        LineItem.attribute_names.each do |fi|
            our_fields.push(fi) if fi != 'incase_id' && fi != 'id' && fi != 'created_at' && fi != 'updated_at'
        end
        our_fields.reject(&:blank?)
    end
    
    def send_excel
        email_data = {
            email_setup: EmailSetup.all.first,
            incase: self,
            strah: self.strah,
            subject: 'Test subject', 
            content: 'Test content', 
            receiver: 'info@k-comment.ru'
          }
        check_email = IncaseMailer.with(email_data).send_info_email.deliver_now #.deliver_later(wait: '1'.to_i.minutes)
        check_email.present? ? true : false      
    end

    private

    def normalize_data_white_space
        self.attributes.each do |key, value|
            self[key] = value.squish if value.respond_to?("squish")
        end
    end
    
end
