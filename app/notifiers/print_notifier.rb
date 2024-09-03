# To deliver this notification:
#
# PrintNotifier.with(record: @post, message: "New post").deliver(User.all)

class PrintNotifier < ApplicationNotifier
  # Add your delivery methods
  deliver_by :turbo_stream, class: "DeliveryMethods::TurboStream"
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
      # recipient.name
      "#{params[:message]}. Печать #{params[:model]} #{","+ params[:error].to_s if !params[:error].nil?}, шаблон #{params[:template]}"
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
