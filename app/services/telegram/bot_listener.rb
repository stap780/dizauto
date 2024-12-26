require 'telegram/bot'

# Telegram::BotListener
class Telegram::BotListener < ApplicationService

  def initialize(token)
    @token = token
    @bot = nil
    @start_keyboard = [[
      Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Загрузить фото', callback_data: 'upload_photo'),
      Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Получить фото', callback_data: 'download_photo')
    ]]
    @start_markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: @start_keyboard, resize_keyboard: true)
    @product = nil
    @media_group_id = nil
    @errors = []
  end

  def call
    message = check_token_and_bot_not_ran_early ? 'we start bot' : @errors
    @bot = Telegram::Bot::Client.new(@token)
    start_work
    [true, message]
  end

  private

  def check_token_and_bot_not_ran_early
    check_token_work = nil
    check_bot_work  = nil
    check_bot = nil
    Telegram::Bot::Client.run(@token) do |bot|
      check_token_work = bot.api.getMe
      check_bot_work = bot.api.get_updates(offset: -1)
      check_bot = bot
    end
    puts "check_token_work => #{check_token_work.to_json}"
    puts "check_bot_work => #{check_bot_work.to_json}"
    puts "check_bot => #{check_bot.to_json}"
    if check_token_work && !check_bot_work.present?
      true
      @bot.stop if @bot.present?
      @bot.api.delete_webhook if @bot.present?
    else
      check_bot.stop
      check_bot.api.delete_webhook
      @bot.stop if @bot.present?
      @bot.api.delete_webhook if @bot.present?
      @errors << 'we stop bot and run again'
      true
    end
  end

  def start_work
    puts '******** start_work *********'
    @bot.run do |bot|
      bot.listen do |update|
        puts "update => #{update.to_json}"
        if check_user(update)
          case update
          when Telegram::Bot::Types::Message
            if update.photo.present? && @product
              load_product_photo(update)
            else
              handle_message(update)
            end
          when Telegram::Bot::Types::CallbackQuery
            handle_callback_query(update)
          when Telegram::Bot::Types::ChatMemberUpdated
            handle_chat_member_updated(update)
          when Telegram::Bot::Types::InlineQuery
            handle_inline_query(update)
          else
            puts "Unprocessed UPDATE of type: #{update.class}"
          end
        else
          @bot.api.send_message(
            chat_id: update.chat.id,
            text: "You are not authorized - Buy,#{update.from.first_name}"
          )
        end
      end
    end
  end

  def check_user(message)
    return false unless User.pluck(:telegram).size.positive?

    username = message.from.username
    User.find_by_telegram(username).present?
  end

  def handle_message(message)
    puts '**********'
    puts "handle_message => #{message.to_json}"
    puts "message.text => #{message.text}"
    puts '**********'

    if message.reply_to_message.present? && message.reply_to_message.text.include?('Укажите штрихкод товара')
      text = message.text # 0000000002585
      @product = Variant.find_by_barcode(text)&.product
      if @product
        result_text = "Найден товар - #{@product.title} \n\nПожалуйста загрузите фотографии"
        @bot.api.send_message(chat_id: message.from.id, text: result_text)
      else
        result_text = "не нашли #{text}. попробуйте другой.\n\nУкажите штрихкод товара"
        force_reply = Telegram::Bot::Types::ForceReply.new(force_reply: true,selective: true)
        @bot.api.send_message(chat_id: message.from.id, text: result_text, reply_markup: force_reply)
      end
    else
      case message.text
      when '/start'
        question = "Hello, #{message.from.first_name}.\n\nЧто вы хотите сделать?"
        @bot.api.send_message(
          chat_id: message.chat.id,
          text: question,
          reply_markup: @start_markup
        )
      when '/stop'
        @bot.api.send_message(
          chat_id: message.chat.id,
          text: "Bye,#{message.from.first_name}",
          reply_markup: Telegram::Bot::Types::ReplyKeyboardRemove.new(remove_keyboard: true)
        )
      when "Завершить работу с товаром #{@product.title}"
        @product = nil
        @bot.api.send_message(
          chat_id: message.chat.id,
          text: '... завершаем',
          reply_markup: Telegram::Bot::Types::ReplyKeyboardRemove.new(remove_keyboard: true)
        )
        @bot.api.send_message(
          chat_id: message.chat.id,
          text: 'Что вы хотите сделать?',
          reply_markup: @start_markup
        )
      when '/photo'
        path_to_photo = File.expand_path("#{Rails.public_path}/test_img/test2.png")
        @bot.api.send_photo(chat_id: message.chat.id, photo: Faraday::UploadIO.new(path_to_photo, 'image/jpeg'))
      else
        handle_unknown_command(message)
      end
    end
  end

  def handle_unknown_command(message)
    @bot.api.send_message(chat_id: message.chat.id, text: 'Unknown command.')
  end

  def handle_callback_query(message)
    # callback_query = message
    puts "Received callback query: #{message.data}"
    if message.data == 'upload_photo'
      # kb = [[
      #   Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Найти по штрихкоду', callback_data: 'search_by_barcode')
      # ]]
      # markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb, resize_keyboard: true)
      force_reply = Telegram::Bot::Types::ForceReply.new(force_reply: true,selective: true)
      @bot.api.send_message(chat_id: message.from.id, text: 'Укажите штрихкод товара', reply_markup: force_reply)
    end
    if message.data == 'download_photo'
      @bot.api.send_message(chat_id: message.from.id, text: 'эта кнопка пока не работает')
    end
  end

  def handle_chat_member_updated(chat_member_updated)
    puts "Update for user: #{chat_member_updated.from.id}"
  end

  def handle_inline_query(message)
    puts "handle_inline_query for user: #{message.from.id}"
  end

  def load_product_photo(message)
    puts "photo => #{message.photo.to_json}"
    # if message.media_group_id.present?
    #   @media_group_id = message.media_group_id
    file = message.photo.last
    get_file(message.chat.id, file)
    # end
  end

  def get_file(chat_id, file)
    # telegram bot files are limited up to 20MB , https://core.telegram.org/bots/api#getfile
    unless validate_file_size(file)
      @bot.api.send_message(
        chat_id: chat_id,
        text: 'Мы не можем обработать ваше сообщение. Размер файла больше 20 MB'
      )
    end

    result = download_file(file[:file_id])
    message = 'Мы не можем получить ваш файл'
    message = 'мы загрузили картинку' if result

    button1 = Telegram::Bot::Types::KeyboardButton.new(text: "Завершить работу с товаром #{@product.title}")
    # button2 = Telegram::Bot::Types::KeyboardButton.new(text: 'button1')
    markup = Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: [[button1]], resize_keyboard: true)

    @bot.api.send_message(
      chat_id: chat_id,
      text: message,
      reply_markup: markup
    )
  end

  def download_file(file_id)
    document = @bot.api.getFile(file_id: file_id)
    link = "https://api.telegram.org/file/bot#{@token}/#{document.file_path}"
    # Product::ImportImage.call(@product.id, [link]) if @product.present?
    ProductImageJob.perform_later(@product.id, [link]) if @product.present?
  end

  def validate_file_size(file)
    puts "validate_file_size => #{file[:file_size]}"
    # Rails.logger.error 'validate_file_size'
    # Rails.logger.error file[:file_size]
    return false if file[:file_size] >= 20.megabytes

    true
  end

  def validate_download(result)
    return false if !result.success? || !result.body

    true
  end

  # Signal.trap("TERM") do
  #   puts 'Shutting down bot...'
  #   @bot.stop
  #   exit
  # end

  # Signal.trap("INT") do
  #   puts 'Shutting down bot...'
  #   @bot.stop
  #   exit
  # end

end

# [
#   {
#     "file_id":"AgACAgIAAxkBAANFZ2MJAAEZPkflnQx2Ve6g9GM7Lj5zAAIn6TEb0FEZS_vmL3i35AFjAQADAgADcwADNgQ",
#     "file_unique_id":"AQADJ-kxG9BRGUt4",
#     "width":51,
#     "height":90,
#     "file_size":1072
#   },
#   {
#     "file_id":"AgACAgIAAxkBAANFZ2MJAAEZPkflnQx2Ve6g9GM7Lj5zAAIn6TEb0FEZS_vmL3i35AFjAQADAgADbQADNgQ",
#     "file_unique_id":"AQADJ-kxG9BRGUty",
#     "width":180,
#     "height":320,
#     "file_size":14381
#   },
#   {
#     "file_id":"AgACAgIAAxkBAANFZ2MJAAEZPkflnQx2Ve6g9GM7Lj5zAAIn6TEb0FEZS_vmL3i35AFjAQADAgADeAADNgQ",
#     "file_unique_id":"AQADJ-kxG9BRGUt9",
#     "width":450,
#     "height":800,
#     "file_size":56627
#   },
#   {
#     "file_id":"AgACAgIAAxkBAANFZ2MJAAEZPkflnQx2Ve6g9GM7Lj5zAAIn6TEb0FEZS_vmL3i35AFjAQADAgADeQADNgQ",
#     "file_unique_id":"AQADJ-kxG9BRGUt-",
#     "width":720,
#     "height":1280,
#     "file_size":102258
#   }
# ]
# 
#
#      # @bot.api.set_my_commands([
      #   Telegram::Bot::Types::BotCommand.new('command1', 'command1 description1'),
      #   Telegram::Bot::Types::BotCommand.new('command2', 'command1 description2')
      # ])
      # commands = {{ command:'command1', description: 'description1' },{ command:'command2', description: 'description2' }}
      # @bot.api.set_my_commands({ command:'command1', description: 'description1' })

      # cl1 = Telegram::Bot::Types::MenuButtonCommands.new({'command1' => 'description1'})
      # cl2 = Telegram::Bot::Types::MenuButtonCommands.new({'command2' => 'description2'})

      # @bot.api.setChatMenuButton( cl1, cl2 )
      # puts "commands menu => #{@bot.api.getMyCommands.to_json}"
      # puts "button menu => #{@bot.api.getChatMenuButton.to_json}"
      # puts "@bot => #{@bot.to_json}"
#
# update => {"message_id":247,"from":{"id":484724219,"is_bot":false,"first_name":"Panaet","last_name":"Em","username":"stap780","language_code":"en"},"chat":{"id":484724219,"first_name":"Panaet","last_name":"Em","username":"stap780","type":"private"},"date":1734957336,"media_group_id":"13879658689810906","photo":[{"file_id":"AgACAgIAAxkBAAP3Z2lZGLRPe6U6rZ-xtHMUVw6NHV4AAqjtMRv6uUlLzwi4hKiYX64BAAMCAANzAAM2BA","file_unique_id":"AQADqO0xG_q5SUt4","width":90,"height":60,"file_size":983},{"file_id":"AgACAgIAAxkBAAP3Z2lZGLRPe6U6rZ-xtHMUVw6NHV4AAqjtMRv6uUlLzwi4hKiYX64BAAMCAANtAAM2BA","file_unique_id":"AQADqO0xG_q5SUty","width":320,"height":212,"file_size":12667},{"file_id":"AgACAgIAAxkBAAP3Z2lZGLRPe6U6rZ-xtHMUVw6NHV4AAqjtMRv6uUlLzwi4hKiYX64BAAMCAAN4AAM2BA","file_unique_id":"AQADqO0xG_q5SUt9","width":800,"height":530,"file_size":50929},{"file_id":"AgACAgIAAxkBAAP3Z2lZGLRPe6U6rZ-xtHMUVw6NHV4AAqjtMRv6uUlLzwi4hKiYX64BAAMCAAN5AAM2BA","file_unique_id":"AQADqO0xG_q5SUt-","width":1144,"height":758,"file_size":77873}]}