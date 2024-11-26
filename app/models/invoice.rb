class Invoice < ApplicationRecord
    audited
    has_many :invoice_items, dependent: :destroy
    accepts_nested_attributes_for :invoice_items, allow_destroy: true
    belongs_to :company, optional: true
    belongs_to :client
    belongs_to :invoice_status
    belongs_to :order, optional: true # это убирает проверку presence: true , которая стоит по дефолту
    after_destroy_commit { broadcast_remove_to "invoices" }

    validates :invoice_items, presence: true

    def self.ransackable_attributes(auth_object = nil)
        Invoice.attribute_names
    end

    def self.ransackable_associations(auth_object = nil)
      %w[associated_audits audits invoice_items]
    end

    private
  
    def normalize_data_white_space
      attributes.each do |key, value|
        self[key] = value.squish if value.respond_to?(:squish)
      end
    end
  
end
