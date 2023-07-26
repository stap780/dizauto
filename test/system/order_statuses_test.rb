require "application_system_test_case"

class OrderStatusesTest < ApplicationSystemTestCase
  setup do
    @order_status = order_statuses(:one)
  end

  test "visiting the index" do
    visit order_statuses_url
    assert_selector "h1", text: "Order statuses"
  end

  test "should create order status" do
    visit order_statuses_url
    click_on "New order status"

    fill_in "Title", with: @order_status.title
    click_on "Create Order status"

    assert_text "Order status was successfully created"
    click_on "Back"
  end

  test "should update Order status" do
    visit order_status_url(@order_status)
    click_on "Edit this order status", match: :first

    fill_in "Title", with: @order_status.title
    click_on "Update Order status"

    assert_text "Order status was successfully updated"
    click_on "Back"
  end

  test "should destroy Order status" do
    visit order_status_url(@order_status)
    click_on "Destroy this order status", match: :first

    assert_text "Order status was successfully destroyed"
  end
end
