require "application_system_test_case"

class SupplyStatusesTest < ApplicationSystemTestCase
  setup do
    @supply_status = supply_statuses(:one)
  end

  test "visiting the index" do
    visit supply_statuses_url
    assert_selector "h1", text: "Supply statuses"
  end

  test "should create supply status" do
    visit supply_statuses_url
    click_on "New supply status"

    fill_in "Color", with: @supply_status.color
    fill_in "Position", with: @supply_status.position
    fill_in "Title", with: @supply_status.title
    click_on "Create Supply status"

    assert_text "Supply status was successfully created"
    click_on "Back"
  end

  test "should update Supply status" do
    visit supply_status_url(@supply_status)
    click_on "Edit this supply status", match: :first

    fill_in "Color", with: @supply_status.color
    fill_in "Position", with: @supply_status.position
    fill_in "Title", with: @supply_status.title
    click_on "Update Supply status"

    assert_text "Supply status was successfully updated"
    click_on "Back"
  end

  test "should destroy Supply status" do
    visit supply_status_url(@supply_status)
    click_on "Destroy this supply status", match: :first

    assert_text "Supply status was successfully destroyed"
  end
end
