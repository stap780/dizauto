require 'telegram/bot'

Rails.application.config.after_initialize do
  puts 'Running Telegram Bot Job!'
  TelegramBotJob.perform_later(TelegramBot.first.token) if TelegramBot.first.present?
end
