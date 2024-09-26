# To deliver this notification:
#
# BulkDeleteNotifier.with(record: @post, message: "New post").deliver(User.all)

class BulkDeleteNotifier < ApplicationNotifier
  deliver_by :turbo_stream, class: "DeliveryMethods::TurboStream"

  notification_methods do

    def message
      "[BulkDeleteNotifier] [#{params[:model]}] => #{params[:message]}"
    end

    def blob #we need this for view notification text
      params[:blob].nil? ? nil : params[:blob]
    end
    
    def success?
      params[:error].nil? ? true : false
    end

  end


  # Add required params
  #
  # required_param :message
end
