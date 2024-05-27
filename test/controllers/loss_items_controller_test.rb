require "test_helper"

class LossItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @loss_item = loss_items(:one)
  end

  test "should get index" do
    get loss_items_url
    assert_response :success
  end

  test "should get new" do
    get new_loss_item_url
    assert_response :success
  end

  test "should create loss_item" do
    assert_difference("LossItem.count") do
      post loss_items_url, params: { loss_item: { loss_id: @loss_item.loss_id, price: @loss_item.price, product_id: @loss_item.product_id, quantity: @loss_item.quantity, sum: @loss_item.sum, vat: @loss_item.vat } }
    end

    assert_redirected_to loss_item_url(LossItem.last)
  end

  test "should show loss_item" do
    get loss_item_url(@loss_item)
    assert_response :success
  end

  test "should get edit" do
    get edit_loss_item_url(@loss_item)
    assert_response :success
  end

  test "should update loss_item" do
    patch loss_item_url(@loss_item), params: { loss_item: { loss_id: @loss_item.loss_id, price: @loss_item.price, product_id: @loss_item.product_id, quantity: @loss_item.quantity, sum: @loss_item.sum, vat: @loss_item.vat } }
    assert_redirected_to loss_item_url(@loss_item)
  end

  test "should destroy loss_item" do
    assert_difference("LossItem.count", -1) do
      delete loss_item_url(@loss_item)
    end

    assert_redirected_to loss_items_url
  end
end
