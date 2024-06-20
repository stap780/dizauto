require "application_system_test_case"

class StockTransfersTest < ApplicationSystemTestCase
  setup do
    @stock_transfer = stock_transfers(:one)
  end

  test "visiting the index" do
    visit stock_transfers_url
    assert_selector "h1", text: "Stock transfers"
  end

  test "should create stock transfer" do
    visit stock_transfers_url
    click_on "New stock transfer"

    fill_in "Destination warehouse", with: @stock_transfer.destination_warehouse_id
    fill_in "Origin warehouse", with: @stock_transfer.origin_warehouse_id
    fill_in "Stock transfer status", with: @stock_transfer.stock_transfer_status_id
    click_on "Create Stock transfer"

    assert_text "Stock transfer was successfully created"
    click_on "Back"
  end

  test "should update Stock transfer" do
    visit stock_transfer_url(@stock_transfer)
    click_on "Edit this stock transfer", match: :first

    fill_in "Destination warehouse", with: @stock_transfer.destination_warehouse_id
    fill_in "Origin warehouse", with: @stock_transfer.origin_warehouse_id
    fill_in "Stock transfer status", with: @stock_transfer.stock_transfer_status_id
    click_on "Update Stock transfer"

    assert_text "Stock transfer was successfully updated"
    click_on "Back"
  end

  test "should destroy Stock transfer" do
    visit stock_transfer_url(@stock_transfer)
    click_on "Destroy this stock transfer", match: :first

    assert_text "Stock transfer was successfully destroyed"
  end
end
