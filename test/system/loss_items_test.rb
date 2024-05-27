require "application_system_test_case"

class LossItemsTest < ApplicationSystemTestCase
  setup do
    @loss_item = loss_items(:one)
  end

  test "visiting the index" do
    visit loss_items_url
    assert_selector "h1", text: "Loss items"
  end

  test "should create loss item" do
    visit loss_items_url
    click_on "New loss item"

    fill_in "Loss", with: @loss_item.loss_id
    fill_in "Price", with: @loss_item.price
    fill_in "Product", with: @loss_item.product_id
    fill_in "Quantity", with: @loss_item.quantity
    fill_in "Sum", with: @loss_item.sum
    fill_in "Vat", with: @loss_item.vat
    click_on "Create Loss item"

    assert_text "Loss item was successfully created"
    click_on "Back"
  end

  test "should update Loss item" do
    visit loss_item_url(@loss_item)
    click_on "Edit this loss item", match: :first

    fill_in "Loss", with: @loss_item.loss_id
    fill_in "Price", with: @loss_item.price
    fill_in "Product", with: @loss_item.product_id
    fill_in "Quantity", with: @loss_item.quantity
    fill_in "Sum", with: @loss_item.sum
    fill_in "Vat", with: @loss_item.vat
    click_on "Update Loss item"

    assert_text "Loss item was successfully updated"
    click_on "Back"
  end

  test "should destroy Loss item" do
    visit loss_item_url(@loss_item)
    click_on "Destroy this loss item", match: :first

    assert_text "Loss item was successfully destroyed"
  end
end
