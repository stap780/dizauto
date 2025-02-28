require "application_system_test_case"

class MitupaisTest < ApplicationSystemTestCase
  setup do
    @mitupai = mitupais(:one)
  end

  test "visiting the index" do
    visit mitupais_url
    assert_selector "h1", text: "Mitupais"
  end

  test "should create mitupai" do
    visit mitupais_url
    click_on "New mitupai"

    fill_in "Api key", with: @mitupai.api_key
    fill_in "Api url", with: @mitupai.api_url
    click_on "Create Mitupai"

    assert_text "Mitupai was successfully created"
    click_on "Back"
  end

  test "should update Mitupai" do
    visit mitupai_url(@mitupai)
    click_on "Edit this mitupai", match: :first

    fill_in "Api key", with: @mitupai.api_key
    fill_in "Api url", with: @mitupai.api_url
    click_on "Update Mitupai"

    assert_text "Mitupai was successfully updated"
    click_on "Back"
  end

  test "should destroy Mitupai" do
    visit mitupai_url(@mitupai)
    click_on "Destroy this mitupai", match: :first

    assert_text "Mitupai was successfully destroyed"
  end
end
