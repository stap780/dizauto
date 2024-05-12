class InventoryStatus < ApplicationRecord
    acts_as_list
    has_many :inventories
  
    before_save :normalize_data_white_space
    before_destroy :check_presence_in_supplies, prepend: true
  
    after_create_commit { broadcast_prepend_to "inventory_statuses" }
    after_update_commit { broadcast_replace_to "inventory_statuses" }
    after_destroy_commit { broadcast_remove_to "inventory_statuses" }
    validates :title, presence: true
  
    def self.ransackable_attributes(auth_object = nil)
        InventoryStatus.attribute_names
    end
  
    private
  
    def normalize_data_white_space
      attributes.each do |key, value|
        self[key] = value.squish if value.respond_to?(:squish)
      end
    end
  
    def check_presence_in_inventories
      if inventories.count > 0
        errors.add(:base, "Cannot delete Status. You have inventories with it.")
        throw(:abort)
      end
    end
end
