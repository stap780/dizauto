# not work
require 'telegram/bot'

# Telegram::BotStop
class Telegram::BotStop < ApplicationService

  def initialize
    token = TelegramBot.first.token
    @bot = Telegram::Bot::Client.new(token)
    Telegram::Bot::Client.run(@token) do |bot|
      @bot = bot
    end
  end

  def call 
    # Signal.trap('INT') do
      @bot.stop
    # end
  end

end