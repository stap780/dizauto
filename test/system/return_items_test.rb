require "application_system_test_case"

class ReturnItemsTest < ApplicationSystemTestCase
  setup do
    @return_item = return_items(:one)
  end

  test "visiting the index" do
    visit return_items_url
    assert_selector "h1", text: "Return items"
  end

  test "should create return item" do
    visit return_items_url
    click_on "New return item"

    fill_in "Discount", with: @return_item.discount
    fill_in "Price", with: @return_item.price
    fill_in "Product", with: @return_item.product_id
    fill_in "Quantity", with: @return_item.quantity
    fill_in "Return", with: @return_item.return_id
    fill_in "Sum", with: @return_item.sum
    fill_in "Vat", with: @return_item.vat
    click_on "Create Return item"

    assert_text "Return item was successfully created"
    click_on "Back"
  end

  test "should update Return item" do
    visit return_item_url(@return_item)
    click_on "Edit this return item", match: :first

    fill_in "Discount", with: @return_item.discount
    fill_in "Price", with: @return_item.price
    fill_in "Product", with: @return_item.product_id
    fill_in "Quantity", with: @return_item.quantity
    fill_in "Return", with: @return_item.return_id
    fill_in "Sum", with: @return_item.sum
    fill_in "Vat", with: @return_item.vat
    click_on "Update Return item"

    assert_text "Return item was successfully updated"
    click_on "Back"
  end

  test "should destroy Return item" do
    visit return_item_url(@return_item)
    click_on "Destroy this return item", match: :first

    assert_text "Return item was successfully destroyed"
  end
end
