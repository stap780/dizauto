require 'telegram/bot'

# Telegram::BotListener
class Telegram::BotListener < ApplicationService

  def initialize(token)
    @token = token
    @client = Telegram::Bot::Client.new(@token)
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
    message = 'wrong token'
    if check_token
      start_work
    end
    [true, message]
  end

  private

  def check_token
    state = true
    begin
      @client.api.getMe
    rescue Telegram::Bot::Exceptions::ResponseError => e
      Rails.logger.error e
      @errors << e
      state = false
    end
    state
  end

  def start_work
    # state = true
    begin
      puts '******** start_work *********'
      @client.run do |bot|
        Rails.application.config.telegram_bot = bot
        bot.api.get_updates(offset: -1)
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
            @client.api.send_message(
              chat_id: update.chat.id,
              text: "You are not authorized - Buy,#{update.from.first_name}"
            )
          end
        end
      end
    rescue Telegram::Bot::Exceptions::ResponseError => e
      Rails.logger.error "We have error => #{e}"
      # @errors << e
      # Rails.application.config.telegram_bot.stop
      # Rails.application.config.telegram_bot.api.delete_webhook
      # state = false
    end
    # state
  end

  def check_user(message)
    return false unless User.pluck(:telegram).size.positive?

    username = message.from.username
    puts "telegram username => #{username}"
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
        @client.api.send_message(chat_id: message.from.id, text: result_text)
      else
        result_text = "не нашли #{text}. попробуйте другой.\n\nУкажите штрихкод товара"
        force_reply = Telegram::Bot::Types::ForceReply.new(force_reply: true,selective: true)
        @client.api.send_message(chat_id: message.from.id, text: result_text, reply_markup: force_reply)
      end
    elsif message.reply_to_message.present? && message.reply_to_message.text.include?('Давайте найдём товар. Укажите штрихкод...')
      text = message.text
      @product = Variant.find_by_barcode(text)&.product
      if @product
        result_text = "Найден товар - #{@product.title} \n\nПожалуйста ожидайте ..."
        @client.api.send_message(chat_id: message.from.id, text: result_text)
        @product.images.each do |image|
          image.file.open do |temp_file|
            path_to_photo = File.expand_path(temp_file) # File.expand_path("#{Rails.public_path}/test_img/test2.png")
            @client.api.send_photo(chat_id: message.chat.id, photo: Faraday::UploadIO.new(path_to_photo, 'image/jpeg'))
          end
        end
        end_text = "Закончили загрузку фотографий по товару - #{@product.title} \nВсего фотографий - #{@product.images.count} шт"

        button1 = Telegram::Bot::Types::KeyboardButton.new(text: "Завершить работу с товаром #{@product.title}")
        # button2 = Telegram::Bot::Types::KeyboardButton.new(text: 'button1')
        markup = Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: [[button1]], resize_keyboard: true)
        @client.api.send_message(chat_id: message.from.id, text: end_text, reply_markup: markup)
      else
        result_text = "не нашли #{text}. попробуйте другой. Должно быть 13 цифр.\n\nДавайте найдём товар. Укажите штрихкод..."
        force_reply = Telegram::Bot::Types::ForceReply.new(force_reply: true,selective: true)
        @client.api.send_message(chat_id: message.from.id, text: result_text, reply_markup: force_reply)
      end
    else
      case message.text
      when '/start'
        question = "Hello, #{message.from.first_name}.\n\nЧто вы хотите сделать?"
        @client.api.send_message(
          chat_id: message.chat.id,
          text: question,
          reply_markup: @start_markup
        )
      when '/stop'
        @client.api.send_message(
          chat_id: message.chat.id,
          text: "Bye,#{message.from.first_name}",
          reply_markup: Telegram::Bot::Types::ReplyKeyboardRemove.new(remove_keyboard: true)
        )
      when "Завершить работу с товаром #{@product&.title}"
        @product = nil
        @client.api.send_message(
          chat_id: message.chat.id,
          text: '... завершаем',
          reply_markup: Telegram::Bot::Types::ReplyKeyboardRemove.new(remove_keyboard: true)
        )
        @client.api.send_message(
          chat_id: message.chat.id,
          text: 'Что вы хотите сделать?',
          reply_markup: @start_markup
        )
      when '/photo'
        path_to_photo = File.expand_path("#{Rails.public_path}/test_img/test2.png")
        @client.api.send_photo(chat_id: message.chat.id, photo: Faraday::UploadIO.new(path_to_photo, 'image/jpeg'))
      else
        handle_unknown_command(message)
      end
    end
  end

  def handle_unknown_command(message)
    @client.api.send_message(chat_id: message.chat.id, text: 'Unknown command.')
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
      @client.api.send_message(chat_id: message.from.id, text: 'Укажите штрихкод товара', reply_markup: force_reply)
    end
    if message.data == 'download_photo'
      # @client.api.send_message(chat_id: message.from.id, text: 'эта кнопка пока не работает')
      force_reply = Telegram::Bot::Types::ForceReply.new(force_reply: true,selective: true)
      @client.api.send_message(chat_id: message.from.id, text: 'Давайте найдём товар. Укажите штрихкод...', reply_markup: force_reply)
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
      @client.api.send_message(
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

    @client.api.send_message(
      chat_id: chat_id,
      text: message,
      reply_markup: markup
    )
  end

  def download_file(file_id)
    document = @client.api.getFile(file_id: file_id)
    link = "https://api.telegram.org/file/bot#{@token}/#{document.file_path}"
    # Product::ImportImage.call(@product.id, [link]) if @product.present?
    ProductImageJob.perform_later(@product.id, [link]) if @product.present?
  end

  def validate_file_size(file)
    puts "validate_file_size => #{file[:file_size]}"
    return false if file[:file_size] >= 20.megabytes

    true
  end

  def validate_download(result)
    return false if !result.success? || !result.body

    true
  end

  Signal.trap("TERM") do
    puts 'Shutting down bot...'
    Rails.application.config.telegram_bot.stop
    exit
  end

  Signal.trap("INT") do
    puts 'Shutting down bot...'
    Rails.application.config.telegram_bot.stop
    exit
  end

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
#      # @client.api.set_my_commands([
      #   Telegram::Bot::Types::BotCommand.new('command1', 'command1 description1'),
      #   Telegram::Bot::Types::BotCommand.new('command2', 'command1 description2')
      # ])
      # commands = {{ command:'command1', description: 'description1' },{ command:'command2', description: 'description2' }}
      # @client.api.set_my_commands({ command:'command1', description: 'description1' })

      # cl1 = Telegram::Bot::Types::MenuButtonCommands.new({'command1' => 'description1'})
      # cl2 = Telegram::Bot::Types::MenuButtonCommands.new({'command2' => 'description2'})

      # @client.api.setChatMenuButton( cl1, cl2 )
      # puts "commands menu => #{@client.api.getMyCommands.to_json}"
      # puts "button menu => #{@client.api.getChatMenuButton.to_json}"
      # puts "@client => #{@client.to_json}"
#
