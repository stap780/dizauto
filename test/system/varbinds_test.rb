require "application_system_test_case"

class VarbindsTest < ApplicationSystemTestCase
  setup do
    @varbind = varbinds(:one)
  end

  test "visiting the index" do
    visit varbinds_url
    assert_selector "h1", text: "Varbinds"
  end

  test "should create varbind" do
    visit varbinds_url
    click_on "New varbind"

    fill_in "Value", with: @varbind.value
    fill_in "Varbindable", with: @varbind.varbindable_id
    fill_in "Varbindable type", with: @varbind.varbindable_type
    fill_in "Variant", with: @varbind.variant_id
    click_on "Create Varbind"

    assert_text "Varbind was successfully created"
    click_on "Back"
  end

  test "should update Varbind" do
    visit varbind_url(@varbind)
    click_on "Edit this varbind", match: :first

    fill_in "Value", with: @varbind.value
    fill_in "Varbindable", with: @varbind.varbindable_id
    fill_in "Varbindable type", with: @varbind.varbindable_type
    fill_in "Variant", with: @varbind.variant_id
    click_on "Update Varbind"

    assert_text "Varbind was successfully updated"
    click_on "Back"
  end

  test "should destroy Varbind" do
    visit varbind_url(@varbind)
    click_on "Destroy this varbind", match: :first

    assert_text "Varbind was successfully destroyed"
  end
end
