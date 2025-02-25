# IncaseMailer < ApplicationMailer
class IncaseMailer < ApplicationMailer
  layout 'incase_mailer'

  before_action { @email_setup, @incase, @subject, @content, @receiver = params[:email_setup], params[:incase], params[:subject], params[:content], params[:receiver] }
  before_action :set_from_email
  after_action :set_delivery_options

  def send_info_email
    @email_from = set_from_email
    xlsx = render_to_string layout: false, handlers: [:axlsx], formats: [:xlsx], template: 'incases/info_email', locals: { incase: @incase }
    # attachment = Base64.encode64(xlsx) - это давало ошибку в файле эксель
    attachments['info_email1.xlsx'] = {
      mime_type: Mime[:xlsx],
      content: xlsx,
      encoding: 'base64'
    }
    mail(to: @receiver, from: @email_from, subject: @subject)
  end

  private

  def set_from_email
    (@email_setup && @email_setup.has_smtp_settings?) ? @email_setup.smtp_settings[:user_name] : 'info@k-comment.ru'
  end

  def set_delivery_options
    if @email_setup && @email_setup.has_smtp_settings?
      mail.delivery_method.settings.merge!(@email_setup.smtp_settings)
    end
  end
end
