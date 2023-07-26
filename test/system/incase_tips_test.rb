require "application_system_test_case"

class IncaseTipsTest < ApplicationSystemTestCase
  setup do
    @incase_tip = incase_tips(:one)
  end

  test "visiting the index" do
    visit incase_tips_url
    assert_selector "h1", text: "Incase tips"
  end

  test "should create incase tip" do
    visit incase_tips_url
    click_on "New incase tip"

    fill_in "Color", with: @incase_tip.color
    fill_in "Title", with: @incase_tip.title
    click_on "Create Incase tip"

    assert_text "Incase tip was successfully created"
    click_on "Back"
  end

  test "should update Incase tip" do
    visit incase_tip_url(@incase_tip)
    click_on "Edit this incase tip", match: :first

    fill_in "Color", with: @incase_tip.color
    fill_in "Title", with: @incase_tip.title
    click_on "Update Incase tip"

    assert_text "Incase tip was successfully updated"
    click_on "Back"
  end

  test "should destroy Incase tip" do
    visit incase_tip_url(@incase_tip)
    click_on "Destroy this incase tip", match: :first

    assert_text "Incase tip was successfully destroyed"
  end
end
