# To deliver this notification:
#
# ExportNotifier.with(record: @post, message: "New post").deliver(User.all)
# ExportNotifier.with(record: Export.first, message: "console ExportJob success", recipient: User.first).deliver(User.first)

class ExportNotifier < ApplicationNotifier
  # Add your delivery methods
  #
  # deliver_by :action_cable do |config|
  #   # config.channel = "Noticed::NotificationChannel"
  #   config.stream = ->{ recipient }
  #   config.message = ->{ params.merge( user_id: recipient.id) }
  # end
  deliver_by :turbo_stream, class: "DeliveryMethods::TurboStream"

  # deliver_by :email do |config|
  #   config.mailer = "UserMailer"
  #   config.method = "create_export"
  #   config.params = -> { params }
  #   # config.args = :email_args
  # end

  def email_args
    {}
  end
    
  notification_methods do
    def message
      "This is  #{recipient.name} from ExportNotifier #{params[:message]}"
    end
    
    def blob
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
