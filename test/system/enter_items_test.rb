require "application_system_test_case"

class EnterItemsTest < ApplicationSystemTestCase
  setup do
    @enter_item = enter_items(:one)
  end

  test "visiting the index" do
    visit enter_items_url
    assert_selector "h1", text: "Enter items"
  end

  test "should create enter item" do
    visit enter_items_url
    click_on "New enter item"

    fill_in "Enter", with: @enter_item.enter_id
    fill_in "Price", with: @enter_item.price
    fill_in "Product", with: @enter_item.product_id
    fill_in "Quantity", with: @enter_item.quantity
    fill_in "Sum", with: @enter_item.sum
    fill_in "Vat", with: @enter_item.vat
    click_on "Create Enter item"

    assert_text "Enter item was successfully created"
    click_on "Back"
  end

  test "should update Enter item" do
    visit enter_item_url(@enter_item)
    click_on "Edit this enter item", match: :first

    fill_in "Enter", with: @enter_item.enter_id
    fill_in "Price", with: @enter_item.price
    fill_in "Product", with: @enter_item.product_id
    fill_in "Quantity", with: @enter_item.quantity
    fill_in "Sum", with: @enter_item.sum
    fill_in "Vat", with: @enter_item.vat
    click_on "Update Enter item"

    assert_text "Enter item was successfully updated"
    click_on "Back"
  end

  test "should destroy Enter item" do
    visit enter_item_url(@enter_item)
    click_on "Destroy this enter item", match: :first

    assert_text "Enter item was successfully destroyed"
  end
end
