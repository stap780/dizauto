require "test_helper"

class StockTransferItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @stock_transfer_item = stock_transfer_items(:one)
  end

  test "should get index" do
    get stock_transfer_items_url
    assert_response :success
  end

  test "should get new" do
    get new_stock_transfer_item_url
    assert_response :success
  end

  test "should create stock_transfer_item" do
    assert_difference("StockTransferItem.count") do
      post stock_transfer_items_url, params: { stock_transfer_item: { price: @stock_transfer_item.price, product_id: @stock_transfer_item.product_id, quantity: @stock_transfer_item.quantity, sum: @stock_transfer_item.sum, vat: @stock_transfer_item.vat } }
    end

    assert_redirected_to stock_transfer_item_url(StockTransferItem.last)
  end

  test "should show stock_transfer_item" do
    get stock_transfer_item_url(@stock_transfer_item)
    assert_response :success
  end

  test "should get edit" do
    get edit_stock_transfer_item_url(@stock_transfer_item)
    assert_response :success
  end

  test "should update stock_transfer_item" do
    patch stock_transfer_item_url(@stock_transfer_item), params: { stock_transfer_item: { price: @stock_transfer_item.price, product_id: @stock_transfer_item.product_id, quantity: @stock_transfer_item.quantity, sum: @stock_transfer_item.sum, vat: @stock_transfer_item.vat } }
    assert_redirected_to stock_transfer_item_url(@stock_transfer_item)
  end

  test "should destroy stock_transfer_item" do
    assert_difference("StockTransferItem.count", -1) do
      delete stock_transfer_item_url(@stock_transfer_item)
    end

    assert_redirected_to stock_transfer_items_url
  end
end
