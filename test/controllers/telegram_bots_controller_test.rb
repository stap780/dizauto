require "test_helper"

class TelegramBotsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @telegram_bot = telegram_bots(:one)
  end

  test "should get index" do
    get telegram_bots_url
    assert_response :success
  end

  test "should get new" do
    get new_telegram_bot_url
    assert_response :success
  end

  test "should create telegram_bot" do
    assert_difference("TelegramBot.count") do
      post telegram_bots_url, params: { telegram_bot: { title: @telegram_bot.title, token: @telegram_bot.token } }
    end

    assert_redirected_to telegram_bot_url(TelegramBot.last)
  end

  test "should show telegram_bot" do
    get telegram_bot_url(@telegram_bot)
    assert_response :success
  end

  test "should get edit" do
    get edit_telegram_bot_url(@telegram_bot)
    assert_response :success
  end

  test "should update telegram_bot" do
    patch telegram_bot_url(@telegram_bot), params: { telegram_bot: { title: @telegram_bot.title, token: @telegram_bot.token } }
    assert_redirected_to telegram_bot_url(@telegram_bot)
  end

  test "should destroy telegram_bot" do
    assert_difference("TelegramBot.count", -1) do
      delete telegram_bot_url(@telegram_bot)
    end

    assert_redirected_to telegram_bots_url
  end
end
