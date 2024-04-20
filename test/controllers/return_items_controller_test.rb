require "test_helper"

class ReturnItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @return_item = return_items(:one)
  end

  test "should get index" do
    get return_items_url
    assert_response :success
  end

  test "should get new" do
    get new_return_item_url
    assert_response :success
  end

  test "should create return_item" do
    assert_difference("ReturnItem.count") do
      post return_items_url, params: { return_item: { discount: @return_item.discount, price: @return_item.price, product_id: @return_item.product_id, quantity: @return_item.quantity, return_id: @return_item.return_id, sum: @return_item.sum, vat: @return_item.vat } }
    end

    assert_redirected_to return_item_url(ReturnItem.last)
  end

  test "should show return_item" do
    get return_item_url(@return_item)
    assert_response :success
  end

  test "should get edit" do
    get edit_return_item_url(@return_item)
    assert_response :success
  end

  test "should update return_item" do
    patch return_item_url(@return_item), params: { return_item: { discount: @return_item.discount, price: @return_item.price, product_id: @return_item.product_id, quantity: @return_item.quantity, return_id: @return_item.return_id, sum: @return_item.sum, vat: @return_item.vat } }
    assert_redirected_to return_item_url(@return_item)
  end

  test "should destroy return_item" do
    assert_difference("ReturnItem.count", -1) do
      delete return_item_url(@return_item)
    end

    assert_redirected_to return_items_url
  end
end
