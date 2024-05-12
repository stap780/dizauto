class StockTransferStatus < ApplicationRecord

    acts_as_list
    has_many :stock_transfers
  
    before_save :normalize_data_white_space
    before_destroy :check_presence_in_stock_transfers, prepend: true
  
    after_create_commit { broadcast_prepend_to "stock_transfer_statuses" }
    after_update_commit { broadcast_replace_to "stock_transfer_statuses" }
    after_destroy_commit { broadcast_remove_to "stock_transfer_statuses" }
    validates :title, presence: true
  
    def self.ransackable_attributes(auth_object = nil)
        StockTransferStatus.attribute_names
    end
  
    private
  
    def normalize_data_white_space
      attributes.each do |key, value|
        self[key] = value.squish if value.respond_to?(:squish)
      end
    end
  
    def check_presence_in_stock_transfers
      if stock_transfers.count > 0
        errors.add(:base, "Cannot delete Status. You have stock transfers with it.")
        throw(:abort)
      end
    end

end
