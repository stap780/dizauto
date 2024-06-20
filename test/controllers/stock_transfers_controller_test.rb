require "test_helper"

class StockTransfersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @stock_transfer = stock_transfers(:one)
  end

  test "should get index" do
    get stock_transfers_url
    assert_response :success
  end

  test "should get new" do
    get new_stock_transfer_url
    assert_response :success
  end

  test "should create stock_transfer" do
    assert_difference("StockTransfer.count") do
      post stock_transfers_url, params: { stock_transfer: { destination_warehouse_id: @stock_transfer.destination_warehouse_id, origin_warehouse_id: @stock_transfer.origin_warehouse_id, stock_transfer_status_id: @stock_transfer.stock_transfer_status_id } }
    end

    assert_redirected_to stock_transfer_url(StockTransfer.last)
  end

  test "should show stock_transfer" do
    get stock_transfer_url(@stock_transfer)
    assert_response :success
  end

  test "should get edit" do
    get edit_stock_transfer_url(@stock_transfer)
    assert_response :success
  end

  test "should update stock_transfer" do
    patch stock_transfer_url(@stock_transfer), params: { stock_transfer: { destination_warehouse_id: @stock_transfer.destination_warehouse_id, origin_warehouse_id: @stock_transfer.origin_warehouse_id, stock_transfer_status_id: @stock_transfer.stock_transfer_status_id } }
    assert_redirected_to stock_transfer_url(@stock_transfer)
  end

  test "should destroy stock_transfer" do
    assert_difference("StockTransfer.count", -1) do
      delete stock_transfer_url(@stock_transfer)
    end

    assert_redirected_to stock_transfers_url
  end
end
