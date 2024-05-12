class LossStatus < ApplicationRecord
    acts_as_list
    has_many :losses
  
    before_save :normalize_data_white_space
    before_destroy :check_presence_in_losses, prepend: true
  
    after_create_commit { broadcast_prepend_to "loss_statuses" }
    after_update_commit { broadcast_replace_to "loss_statuses" }
    after_destroy_commit { broadcast_remove_to "loss_statuses" }
    validates :title, presence: true
  
    def self.ransackable_attributes(auth_object = nil)
        LossStatus.attribute_names
    end
  
    private
  
    def normalize_data_white_space
      attributes.each do |key, value|
        self[key] = value.squish if value.respond_to?(:squish)
      end
    end
  
    def check_presence_in_losses
      if losses.count > 0
        errors.add(:base, "Cannot delete Loss Status. You have losses with it.")
        throw(:abort)
      end
    end
end
