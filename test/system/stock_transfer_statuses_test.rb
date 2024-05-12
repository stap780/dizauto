require "application_system_test_case"

class StockTransferStatusesTest < ApplicationSystemTestCase
  setup do
    @stock_transfer_status = stock_transfer_statuses(:one)
  end

  test "visiting the index" do
    visit stock_transfer_statuses_url
    assert_selector "h1", text: "Stock transfer statuses"
  end

  test "should create stock transfer status" do
    visit stock_transfer_statuses_url
    click_on "New stock transfer status"

    fill_in "Color", with: @stock_transfer_status.color
    fill_in "Position", with: @stock_transfer_status.position
    fill_in "Title", with: @stock_transfer_status.title
    click_on "Create Stock transfer status"

    assert_text "Stock transfer status was successfully created"
    click_on "Back"
  end

  test "should update Stock transfer status" do
    visit stock_transfer_status_url(@stock_transfer_status)
    click_on "Edit this stock transfer status", match: :first

    fill_in "Color", with: @stock_transfer_status.color
    fill_in "Position", with: @stock_transfer_status.position
    fill_in "Title", with: @stock_transfer_status.title
    click_on "Update Stock transfer status"

    assert_text "Stock transfer status was successfully updated"
    click_on "Back"
  end

  test "should destroy Stock transfer status" do
    visit stock_transfer_status_url(@stock_transfer_status)
    click_on "Destroy this stock transfer status", match: :first

    assert_text "Stock transfer status was successfully destroyed"
  end
end
