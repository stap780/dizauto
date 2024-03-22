require "test_helper"

class LineItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @line_item = line_items(:one)
  end

  test "should get index" do
    get line_items_url
    assert_response :success
  end

  test "should get new" do
    get new_line_item_url
    assert_response :success
  end

  test "should create line_item" do
    assert_difference("LineItem.count") do
      post line_items_url, params: {line_item: {incase_id: @line_item.incase_id, katnumber: @line_item.katnumber, price: @line_item.price, quantity: @line_item.quantity, status: @line_item.status, sum: @line_item.sum, title: @line_item.title}}
    end

    assert_redirected_to line_item_url(LineItem.last)
  end

  test "should show line_item" do
    get line_item_url(@line_item)
    assert_response :success
  end

  test "should get edit" do
    get edit_line_item_url(@line_item)
    assert_response :success
  end

  test "should update line_item" do
    patch line_item_url(@line_item), params: {line_item: {incase_id: @line_item.incase_id, katnumber: @line_item.katnumber, price: @line_item.price, quantity: @line_item.quantity, status: @line_item.status, sum: @line_item.sum, title: @line_item.title}}
    assert_redirected_to line_item_url(@line_item)
  end

  test "should destroy line_item" do
    assert_difference("LineItem.count", -1) do
      delete line_item_url(@line_item)
    end

    assert_redirected_to line_items_url
  end
end
