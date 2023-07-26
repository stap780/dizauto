require "application_system_test_case"

class IncaseStatusesTest < ApplicationSystemTestCase
  setup do
    @incase_status = incase_statuses(:one)
  end

  test "visiting the index" do
    visit incase_statuses_url
    assert_selector "h1", text: "Incase statuses"
  end

  test "should create incase status" do
    visit incase_statuses_url
    click_on "New incase status"

    fill_in "Color", with: @incase_status.color
    fill_in "Title", with: @incase_status.title
    click_on "Create Incase status"

    assert_text "Incase status was successfully created"
    click_on "Back"
  end

  test "should update Incase status" do
    visit incase_status_url(@incase_status)
    click_on "Edit this incase status", match: :first

    fill_in "Color", with: @incase_status.color
    fill_in "Title", with: @incase_status.title
    click_on "Update Incase status"

    assert_text "Incase status was successfully updated"
    click_on "Back"
  end

  test "should destroy Incase status" do
    visit incase_status_url(@incase_status)
    click_on "Destroy this incase status", match: :first

    assert_text "Incase status was successfully destroyed"
  end
end
