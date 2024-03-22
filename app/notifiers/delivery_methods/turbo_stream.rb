class DeliveryMethods::TurboStream < ApplicationDeliveryMethod
    def deliver
      return unless recipient.is_a?(User)
      # puts "+++++++"
      # puts notification.to_json
      # puts "recipient"
      # puts recipient.to_json
      # puts "+++++++"
      notification.broadcast_update_to_bell
      notification.broadcast_replace_to_noti_count
      notification.broadcast_prepend_to_noti_snippet
      notification.broadcast_replace_to_index_count
      notification.broadcast_prepend_to_index_list
    end
end

#{"id":50,"event_id":51,"recipient_type":"User","recipient_id":1,"read_at":null,"seen_at":null,"created_at":"2024-03-16T16:15:32.676+03:00","updated_at":"2024-03-16T16:15:32.676+03:00"}