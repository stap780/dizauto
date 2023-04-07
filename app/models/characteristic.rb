class Characteristic < ApplicationRecord
    belongs_to :property

    def self.ransackable_attributes(auth_object = nil)
      ["created_at", "id", "property_id", "title", "updated_at"]
    end

end
