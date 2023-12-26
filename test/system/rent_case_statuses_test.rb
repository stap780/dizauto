require "application_system_test_case"

class RentCaseStatusesTest < ApplicationSystemTestCase
  setup do
    @rent_case_status = rent_case_statuses(:one)
  end

  test "visiting the index" do
    visit rent_case_statuses_url
    assert_selector "h1", text: "Rent case statuses"
  end

  test "should create rent case status" do
    visit rent_case_statuses_url
    click_on "New rent case status"

    fill_in "Color", with: @rent_case_status.color
    fill_in "Position", with: @rent_case_status.position
    fill_in "Title", with: @rent_case_status.title
    click_on "Create Rent case status"

    assert_text "Rent case status was successfully created"
    click_on "Back"
  end

  test "should update Rent case status" do
    visit rent_case_status_url(@rent_case_status)
    click_on "Edit this rent case status", match: :first

    fill_in "Color", with: @rent_case_status.color
    fill_in "Position", with: @rent_case_status.position
    fill_in "Title", with: @rent_case_status.title
    click_on "Update Rent case status"

    assert_text "Rent case status was successfully updated"
    click_on "Back"
  end

  test "should destroy Rent case status" do
    visit rent_case_status_url(@rent_case_status)
    click_on "Destroy this rent case status", match: :first

    assert_text "Rent case status was successfully destroyed"
  end
end
