require "application_system_test_case"

class DetalPropsTest < ApplicationSystemTestCase
  setup do
    @detal_prop = detal_props(:one)
  end

  test "visiting the index" do
    visit detal_props_url
    assert_selector "h1", text: "Detal props"
  end

  test "should create detal prop" do
    visit detal_props_url
    click_on "New detal prop"

    fill_in "Characteristic", with: @detal_prop.characteristic_id
    fill_in "Property", with: @detal_prop.property_id
    click_on "Create Detal prop"

    assert_text "Detal prop was successfully created"
    click_on "Back"
  end

  test "should update Detal prop" do
    visit detal_prop_url(@detal_prop)
    click_on "Edit this detal prop", match: :first

    fill_in "Characteristic", with: @detal_prop.characteristic_id
    fill_in "Property", with: @detal_prop.property_id
    click_on "Update Detal prop"

    assert_text "Detal prop was successfully updated"
    click_on "Back"
  end

  test "should destroy Detal prop" do
    visit detal_prop_url(@detal_prop)
    click_on "Destroy this detal prop", match: :first

    assert_text "Detal prop was successfully destroyed"
  end
end
