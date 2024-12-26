# TelegramBotJob
class TelegramBotJob < ApplicationJob
  queue_as :default
  sidekiq_options retry: 0

  def perform(token)
    if TelegramBot.first.token
      puts 'Starting bot from job ...'
      Rails.logger.info 'Starting bot from job ...'
      Telegram::BotListener.call(token)
    end
  end
end
