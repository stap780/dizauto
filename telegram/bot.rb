# # Import the environment config and library
# require File.expand_path('../config/environment', __dir__)
# require 'telegram/bot'

# token = '7833346949:AAFvAgotpTMBSt4-BH9w4oTenawwZj886fc' #TelegramBot.first.token

# Telegram::Bot::Client.run(token) do |bot|
#   bot.listen do |message|
#     case message.text
#     when '/start'
#       bot.api.send_message(
#         chat_id: message.chat.id,
#         text: "Hello,
#         #{message.from.first_name}"
#       )
#     when '/stop'
#       bot.api.send_message(
#         chat_id: message.chat.id,
#         text: "Bye,
#         #{message.from.first_name}"
#       )
#     end
#   end
# end