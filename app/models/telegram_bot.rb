# TelegramBot
class TelegramBot < ApplicationRecord
  after_create_commit { broadcast_append_to 'telegram_bots' }
  after_update_commit { broadcast_replace_to 'telegram_bots' }
  after_destroy_commit { broadcast_remove_to 'telegram_bots' }

  validates :token, presence: true

  def self.ransackable_attributes(auth_object = nil)
    TelegramBot.attribute_names
  end

end
