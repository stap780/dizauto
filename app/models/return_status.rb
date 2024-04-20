class ReturnStatus < ApplicationRecord
    acts_as_list
    has_many :returns
    after_create_commit { broadcast_prepend_to "return_statuses" }
    after_update_commit { broadcast_replace_to "return_statuses" }
    after_destroy_commit { broadcast_remove_to "return_statuses" }
    before_save :normalize_data_white_space
    before_destroy :check_presence_in_returns, prepend: true

    validates :title, presence: true
  
    def self.ransackable_attributes(auth_object = nil)
        ReturnStatus.attribute_names
    end
  
    private
  
    def normalize_data_white_space
      attributes.each do |key, value|
        self[key] = value.squish if value.respond_to?(:squish)
      end
    end

    def check_presence_in_returns
        if returns.count > 0
          errors.add(:base, "Cannot delete Return Status. You have returns with it.")
          throw(:abort)
        end
    end

end
