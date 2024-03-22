module Noticed::NotificationExtensions
    extend ActiveSupport::Concern
  
    def broadcast_update_to_bell
      broadcast_update_to(
        recipient,
        "notifications_bell_#{recipient.id}",
        target: "notification_bell",
        partial: "notifications/bell",
        locals: { count: recipient.notifications.count, unread: recipient.notifications.unread.count }
      )
    end
  
    def broadcast_replace_to_noti_count
      broadcast_replace_to(
        recipient,
        "notification_widget_count_#{recipient.id}",
        target: "notification_widget_count",
        partial: "notifications/widget_count",
        locals: { count: recipient.notifications.count, unread: recipient.notifications.unread.count }
      )
    end
  
    def broadcast_prepend_to_noti_snippet
        broadcast_prepend_to(
          recipient,
          "notification_widget_#{recipient.id}",
          target: "notification_widget",
          partial: "notifications/noti_snippet",
          locals: { notification: self }
        )
    end

    def broadcast_replace_to_index_count
        broadcast_replace_to(
          recipient,
          "notifications_index_list_count_#{recipient.id}",
          target: "notification_index_list_count",
          partial: "notifications/index_list_count",
          locals: { count: recipient.notifications.count, unread: recipient.notifications.unread.count }
        )
    end  

    def broadcast_prepend_to_index_list
      broadcast_prepend_to(
        recipient,
        "notifications_index_list_#{recipient.id}",
        target: "notifications",
        partial: "notifications/notification",
        locals: { notification: self }
      )
    end

  
  end

