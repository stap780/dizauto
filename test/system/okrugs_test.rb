require "application_system_test_case"

class OkrugsTest < ApplicationSystemTestCase
  setup do
    @okrug = okrugs(:one)
  end

  test "visiting the index" do
    visit okrugs_url
    assert_selector "h1", text: "Okrugs"
  end

  test "should create okrug" do
    visit okrugs_url
    click_on "New okrug"

    fill_in "Title", with: @okrug.title
    click_on "Create Okrug"

    assert_text "Okrug was successfully created"
    click_on "Back"
  end

  test "should update Okrug" do
    visit okrug_url(@okrug)
    click_on "Edit this okrug", match: :first

    fill_in "Title", with: @okrug.title
    click_on "Update Okrug"

    assert_text "Okrug was successfully updated"
    click_on "Back"
  end

  test "should destroy Okrug" do
    visit okrug_url(@okrug)
    click_on "Destroy this okrug", match: :first

    assert_text "Okrug was successfully destroyed"
  end
end
