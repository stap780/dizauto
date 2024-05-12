require "application_system_test_case"

class InventoryStatusesTest < ApplicationSystemTestCase
  setup do
    @inventory_status = inventory_statuses(:one)
  end

  test "visiting the index" do
    visit inventory_statuses_url
    assert_selector "h1", text: "Inventory statuses"
  end

  test "should create inventory status" do
    visit inventory_statuses_url
    click_on "New inventory status"

    fill_in "Color", with: @inventory_status.color
    fill_in "Position", with: @inventory_status.position
    fill_in "Title", with: @inventory_status.title
    click_on "Create Inventory status"

    assert_text "Inventory status was successfully created"
    click_on "Back"
  end

  test "should update Inventory status" do
    visit inventory_status_url(@inventory_status)
    click_on "Edit this inventory status", match: :first

    fill_in "Color", with: @inventory_status.color
    fill_in "Position", with: @inventory_status.position
    fill_in "Title", with: @inventory_status.title
    click_on "Update Inventory status"

    assert_text "Inventory status was successfully updated"
    click_on "Back"
  end

  test "should destroy Inventory status" do
    visit inventory_status_url(@inventory_status)
    click_on "Destroy this inventory status", match: :first

    assert_text "Inventory status was successfully destroyed"
  end
end
