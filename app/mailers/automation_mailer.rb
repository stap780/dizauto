class AutomationMailer < ApplicationMailer
  before_action { @email_setup, @subject, @content, @receiver = params[:email_setup], params[:subject], params[:content], params[:receiver] }
  before_action :set_from_email
  after_action :set_delivery_options

  def send_action_email
    @email_from = set_from_email
    mail(to: @receiver, from: @email_from, subject: @subject)
  end

  private

  def set_from_email
    (@email_setup && @email_setup.has_smtp_settings?) ? @email_setup.smtp_settings[:user_name] : "info@k-comment.ru"
  end

  def set_delivery_options
    if @email_setup && @email_setup.has_smtp_settings?
      mail.delivery_method.settings.merge!(@email_setup.smtp_settings)
    end
  end
end
