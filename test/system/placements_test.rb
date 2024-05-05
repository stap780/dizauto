require "application_system_test_case"

class PlacementsTest < ApplicationSystemTestCase
  setup do
    @placement = placements(:one)
  end

  test "visiting the index" do
    visit placements_url
    assert_selector "h1", text: "Placements"
  end

  test "should create placement" do
    visit placements_url
    click_on "New placement"

    fill_in "Warehouse", with: @placement.warehouse_id
    click_on "Create Placement"

    assert_text "Placement was successfully created"
    click_on "Back"
  end

  test "should update Placement" do
    visit placement_url(@placement)
    click_on "Edit this placement", match: :first

    fill_in "Warehouse", with: @placement.warehouse_id
    click_on "Update Placement"

    assert_text "Placement was successfully updated"
    click_on "Back"
  end

  test "should destroy Placement" do
    visit placement_url(@placement)
    click_on "Destroy this placement", match: :first

    assert_text "Placement was successfully destroyed"
  end
end
