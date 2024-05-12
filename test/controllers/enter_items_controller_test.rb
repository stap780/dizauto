require "test_helper"

class EnterItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @enter_item = enter_items(:one)
  end

  test "should get index" do
    get enter_items_url
    assert_response :success
  end

  test "should get new" do
    get new_enter_item_url
    assert_response :success
  end

  test "should create enter_item" do
    assert_difference("EnterItem.count") do
      post enter_items_url, params: { enter_item: { enter_id: @enter_item.enter_id, price: @enter_item.price, product_id: @enter_item.product_id, quantity: @enter_item.quantity, sum: @enter_item.sum, vat: @enter_item.vat } }
    end

    assert_redirected_to enter_item_url(EnterItem.last)
  end

  test "should show enter_item" do
    get enter_item_url(@enter_item)
    assert_response :success
  end

  test "should get edit" do
    get edit_enter_item_url(@enter_item)
    assert_response :success
  end

  test "should update enter_item" do
    patch enter_item_url(@enter_item), params: { enter_item: { enter_id: @enter_item.enter_id, price: @enter_item.price, product_id: @enter_item.product_id, quantity: @enter_item.quantity, sum: @enter_item.sum, vat: @enter_item.vat } }
    assert_redirected_to enter_item_url(@enter_item)
  end

  test "should destroy enter_item" do
    assert_difference("EnterItem.count", -1) do
      delete enter_item_url(@enter_item)
    end

    assert_redirected_to enter_items_url
  end
end
