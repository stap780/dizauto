require "application_system_test_case"

class TelegramBotsTest < ApplicationSystemTestCase
  setup do
    @telegram_bot = telegram_bots(:one)
  end

  test "visiting the index" do
    visit telegram_bots_url
    assert_selector "h1", text: "Telegram bots"
  end

  test "should create telegram bot" do
    visit telegram_bots_url
    click_on "New telegram bot"

    fill_in "Title", with: @telegram_bot.title
    fill_in "Token", with: @telegram_bot.token
    click_on "Create Telegram bot"

    assert_text "Telegram bot was successfully created"
    click_on "Back"
  end

  test "should update Telegram bot" do
    visit telegram_bot_url(@telegram_bot)
    click_on "Edit this telegram bot", match: :first

    fill_in "Title", with: @telegram_bot.title
    fill_in "Token", with: @telegram_bot.token
    click_on "Update Telegram bot"

    assert_text "Telegram bot was successfully updated"
    click_on "Back"
  end

  test "should destroy Telegram bot" do
    visit telegram_bot_url(@telegram_bot)
    click_on "Destroy this telegram bot", match: :first

    assert_text "Telegram bot was successfully destroyed"
  end
end
