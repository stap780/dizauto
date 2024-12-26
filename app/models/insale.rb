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
      # puts "StandardError => "+e.to_s
      # puts "e.response => "+e.response.to_s if e.response
      # puts "e.response.body => "+e.response.body.to_s if e.response && e.response.body
      message << "StandardError #{e}"
    else
      account
    end
    # account.blocked == false
    message.size.positive? ? [false, message] : [true, '']
  end
end
