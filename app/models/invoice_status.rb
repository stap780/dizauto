class InvoiceStatus < ApplicationRecord
    acts_as_list
    has_many :invoices
    after_create_commit { broadcast_prepend_to "invoice_statuses" }
    after_update_commit { broadcast_replace_to "invoice_statuses" }
    after_destroy_commit { broadcast_remove_to "invoice_statuses" }
    before_save :normalize_data_white_space
    before_destroy :check_presence_in_invoices, prepend: true

    validates :title, presence: true
  
    def self.ransackable_attributes(auth_object = nil)
        InvoiceStatus.attribute_names
    end
  
    private
  
    def normalize_data_white_space
      attributes.each do |key, value|
        self[key] = value.squish if value.respond_to?(:squish)
      end
    end

    def check_presence_in_invoices
        if invoices.count > 0
          errors.add(:base, "Cannot delete Invoice Status. You have invoices with it.")
          throw(:abort)
        end
    end

end
