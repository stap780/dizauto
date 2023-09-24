require "application_system_test_case"

class SuppliesTest < ApplicationSystemTestCase
  setup do
    @supply = supplies(:one)
  end

  test "visiting the index" do
    visit supplies_url
    assert_selector "h1", text: "Supplies"
  end

  test "should create supply" do
    visit supplies_url
    click_on "New supply"

    fill_in "Company", with: @supply.company_id
    fill_in "Warehouse", with: @supply.warehouse_id
    click_on "Create Supply"

    assert_text "Supply was successfully created"
    click_on "Back"
  end

  test "should update Supply" do
    visit supply_url(@supply)
    click_on "Edit this supply", match: :first

    fill_in "Company", with: @supply.company_id
    fill_in "Warehouse", with: @supply.warehouse_id
    click_on "Update Supply"

    assert_text "Supply was successfully updated"
    click_on "Back"
  end

  test "should destroy Supply" do
    visit supply_url(@supply)
    click_on "Destroy this supply", match: :first

    assert_text "Supply was successfully destroyed"
  end
end
