# To deliver this notification:
#
# PrintNotifier.with(record: @post, message: "New post").deliver(User.all)

class PrintNotifier < ApplicationNotifier
  # Add your delivery methods
  #
  # deliver_by :email do |config|
  #   config.mailer = "UserMailer"
  #   config.method = "new_post"
  # end
  #
  # bulk_deliver_by :slack do |config|
  #   config.url = -> { Rails.application.credentials.slack_webhook_url }
  # end
  #
  # deliver_by :custom do |config|
  #   config.class = "MyDeliveryMethod"
  # end

  notification_methods do
    def message
      "This is  #{recipient.name} from PrintNotifier #{params[:message]}"
    end
  end

  # Add required params
  #
  # required_param :message
end
