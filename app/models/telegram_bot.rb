# TelegramBot
class TelegramBot < ApplicationRecord
  include NormalizeDataWhiteSpace
  after_create_commit { broadcast_append_to 'telegram_bots' }
  after_update_commit { broadcast_replace_to 'telegram_bots' }
  after_destroy_commit { broadcast_remove_to 'telegram_bots' }

  validates :title, presence: true
  validates :token, presence: true, uniqueness: true

  def self.ransackable_attributes(auth_object = nil)
    attribute_names
  end

end
