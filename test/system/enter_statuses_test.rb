require "application_system_test_case"

class EnterStatusesTest < ApplicationSystemTestCase
  setup do
    @enter_status = enter_statuses(:one)
  end

  test "visiting the index" do
    visit enter_statuses_url
    assert_selector "h1", text: "Enter statuses"
  end

  test "should create enter status" do
    visit enter_statuses_url
    click_on "New enter status"

    fill_in "Color", with: @enter_status.color
    fill_in "Position", with: @enter_status.position
    fill_in "Title", with: @enter_status.title
    click_on "Create Enter status"

    assert_text "Enter status was successfully created"
    click_on "Back"
  end

  test "should update Enter status" do
    visit enter_status_url(@enter_status)
    click_on "Edit this enter status", match: :first

    fill_in "Color", with: @enter_status.color
    fill_in "Position", with: @enter_status.position
    fill_in "Title", with: @enter_status.title
    click_on "Update Enter status"

    assert_text "Enter status was successfully updated"
    click_on "Back"
  end

  test "should destroy Enter status" do
    visit enter_status_url(@enter_status)
    click_on "Destroy this enter status", match: :first

    assert_text "Enter status was successfully destroyed"
  end
end
