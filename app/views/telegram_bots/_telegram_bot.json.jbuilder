json.extract! telegram_bot, :id, :title, :token, :created_at, :updated_at
json.url telegram_bot_url(telegram_bot, format: :json)
