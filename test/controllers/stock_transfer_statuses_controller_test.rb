require "test_helper"

class StockTransferStatusesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @stock_transfer_status = stock_transfer_statuses(:one)
  end

  test "should get index" do
    get stock_transfer_statuses_url
    assert_response :success
  end

  test "should get new" do
    get new_stock_transfer_status_url
    assert_response :success
  end

  test "should create stock_transfer_status" do
    assert_difference("StockTransferStatus.count") do
      post stock_transfer_statuses_url, params: { stock_transfer_status: { color: @stock_transfer_status.color, position: @stock_transfer_status.position, title: @stock_transfer_status.title } }
    end

    assert_redirected_to stock_transfer_status_url(StockTransferStatus.last)
  end

  test "should show stock_transfer_status" do
    get stock_transfer_status_url(@stock_transfer_status)
    assert_response :success
  end

  test "should get edit" do
    get edit_stock_transfer_status_url(@stock_transfer_status)
    assert_response :success
  end

  test "should update stock_transfer_status" do
    patch stock_transfer_status_url(@stock_transfer_status), params: { stock_transfer_status: { color: @stock_transfer_status.color, position: @stock_transfer_status.position, title: @stock_transfer_status.title } }
    assert_redirected_to stock_transfer_status_url(@stock_transfer_status)
  end

  test "should destroy stock_transfer_status" do
    assert_difference("StockTransferStatus.count", -1) do
      delete stock_transfer_status_url(@stock_transfer_status)
    end

    assert_redirected_to stock_transfer_statuses_url
  end
end
