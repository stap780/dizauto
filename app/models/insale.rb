# Insale < ApplicationRecord
class Insale < ApplicationRecord
  validates :api_link, presence: true
  validates :api_key, presence: true
  validates :api_password, presence: true
  after_create_commit { broadcast_append_to 'insales' }
  after_update_commit { broadcast_replace_to 'insales' }
  after_destroy_commit { broadcast_remove_to 'insales' }

  def self.ransackable_attributes(auth_object = nil)
    Insale.attribute_names
  end

  def self.api_init
    return false unless Insale.first.present?

    InsalesApi::App.api_key = Insale.first.api_key
    InsalesApi::App.configure_api(Insale.first.api_link, Insale.first.api_password)
  end

  def self.api_work?
    return false unless Insale.first.present?

    Insale.api_init
    message = []
    begin
      account = InsalesApi::Account.find
    rescue SocketError
      message << 'SocketError Check Key,Password,Domain'
    rescue ActiveResource::ResourceNotFound
      message << 'not_found 404'
    rescue ActiveResource::ResourceConflict, ActiveResource::ResourceInvalid
      message << 'ActiveResource::ResourceConflict, ActiveResource::ResourceInvalid'
    rescue ActiveResource::UnauthorizedAccess
      message << 'Failed.  Response code = 401.  Response message = Unauthorized'
    rescue ActiveResource::ForbiddenAccess
      message << 'Failed.  Response code = 403.  Response message = Forbidden.'
    rescue StandardError => e
      message << "StandardError #{e}"
    else
      account
    end
    # account.blocked == false
    message.size.positive? ? [false, message] : [true, '']
  end

  def self.add_order_webhook
    return false unless Insale.first.present? && Insale.api_work?

    webh_list = InsalesApi::Webhook.all
    check_present = webh_list.map{|w| w.topic == 'orders/create' && w.address == 'https://erp.dizauto.ru/insales/order'}[0]
    if check_present
      message = 'вебхук уже существует. всё работает'
    else
      data_webhook_order_create = {
        address: 'https://erp.dizauto.ru/insales/order',
        topic: 'orders/create',
        format_type: 'json'
      }
      message = []
      webhook_order_create = InsalesApi::Webhook.new(webhook: data_webhook_order_create)
      begin
        webhook_order_create.save
      rescue SocketError
        message << 'SocketError Check Key,Password,Domain'
      rescue ActiveResource::ResourceNotFound
        message << 'not_found 404'
      rescue ActiveResource::ResourceConflict, ActiveResource::ResourceInvalid
        message << 'ActiveResource::ResourceConflict, ActiveResource::ResourceInvalid'
      rescue ActiveResource::UnauthorizedAccess
        message << 'Failed.  Response code = 401.  Response message = Unauthorized'
      rescue ActiveResource::ForbiddenAccess
        message << 'Failed.  Response code = 403.  Response message = Forbidden.'
      rescue StandardError => e
        message << "StandardError #{e}"
      else
        webhook_order_create
      end
    end
    message.size.positive? ? [false, message] : [true, '']
  end

end
