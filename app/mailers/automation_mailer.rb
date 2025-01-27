# AutomationMailer < ApplicationMailer
class AutomationMailer < ApplicationMailer
  before_action { @email_setup, @subject, @content, @receiver, @attachment, @attachment_items, @attachment_template_id = params[:email_setup], params[:subject], params[:content], params[:receiver], params[:attachment], params[:attachment_items], params[:attachment_template_id] }
  before_action :set_from_email
  after_action :set_delivery_options

  def send_action_email
    @email_from = set_from_email
    set_attachment if @attachment
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

  def set_attachment
    success, blob = Bulk::Print.new([@attachment_items], {templ_id: @attachment_template_id}).call
    if success
      if blob.is_a?(ActiveStorage::Blob)
        attachments[blob.filename.to_s] = {
          mime_type: blob.content_type,
          content: blob.download
        }
        blob.purge
      end
    end
  end

end
