# UserMailer < ApplicationMailer
class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #   en.user_mailer.create_export.subject
  #
  before_action { @email_setup, @subject, @receiver = params[:email_setup], params[:subject], params[:receiver] }
  before_action :set_from_email
  after_action :set_delivery_options

  def create_export
    puts "create_export_________"
    puts params
    @greeting = params[:message]

    mail to: params[:recipient].email #"panaet80@gmail.com"
  end

  def welcome_email
    @email_from = set_from_email
    @url  = 'https://erp.dizauto.ru/login'
    mail(to: @receiver.email, from: @email_from, subject: @subject)
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
