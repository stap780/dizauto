class Incase < ApplicationRecord
    audited
    belongs_to :incase_status
    belongs_to :incase_tip
    belongs_to :company
    belongs_to :strah, class_name: "Company", foreign_key: "strah_id"
    has_many   :incase_items, dependent: :destroy
	accepts_nested_attributes_for :incase_items, allow_destroy: true, :reject_if => :all_blank #, reject_if: proc { |attributes| attributes['здесь пишем атрибут из incase_items'].blank? }
    has_associated_audits
    
    before_save :normalize_data_white_space

	validates :date, presence: true
	validates :unumber, presence: true
    validates :incase_items, presence: true


    REGION = ['МСК', 'СПБ'].freeze
    
    def self.ransackable_associations(auth_object = nil)
        ["associated_audits", "audits", "company", "incase_items", "strah", "incase_status", "incase_tip"]
    end

    def self.ransackable_attributes(auth_object = nil)
        Incase.attribute_names
    end

    def self.import_attributes
        our_fields = []
        incases = []
        incase_items = []
        Incase.attribute_names.each do |fi| 
            # fi = 'company' if fi == 'company_id' # fi = 'strah' if fi == 'strah_id'
            incases.push(fi) if fi != 'id' && fi != 'created_at' && fi != 'updated_at' && fi != 'incase_status_id' && fi != 'incase_tip_id'
        end
        incase_hash = Hash.new
        incase_hash['incase'] = incases.reject(&:blank?)
        our_fields.push(incase_hash)
        IncaseItem.attribute_names.each do |fi|
            incase_items.push(fi) if fi != 'incase_id' && fi != 'id' && fi != 'created_at' && fi != 'updated_at' && fi != 'incase_item_status_id'
        end
        incase_item_hash = Hash.new
        incase_item_hash['incase_item'] = incase_items.reject(&:blank?)
        our_fields.push(incase_item_hash)
        #puts our_fields.to_s
        our_fields
    end
    
    def send_excel
        email_data = {
            email_setup: EmailSetup.all.first,
            incase: self,
            subject: 'Test subject',
            content: 'Test content',
            receiver: self.strah.main_email
          }
        check_email = IncaseMailer.with(email_data).send_info_email.deliver_now #.deliver_later(wait: '1'.to_i.minutes)
        check_email.present? ? true : false
    end

    def automation_on_create
        Automation.new(self).create
    end

    def automation_on_update
        Automation.new(self).update
    end

    private

    def normalize_data_white_space
        self.attributes.each do |key, value|
            self[key] = value.squish if value.respond_to?("squish")
        end
    end
    
end
