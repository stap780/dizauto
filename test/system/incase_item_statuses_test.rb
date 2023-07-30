require "application_system_test_case"

class IncaseItemStatusesTest < ApplicationSystemTestCase
  setup do
    @incase_item_status = incase_item_statuses(:one)
  end

  test "visiting the index" do
    visit incase_item_statuses_url
    assert_selector "h1", text: "Incase item statuses"
  end

  test "should create incase item status" do
    visit incase_item_statuses_url
    click_on "New incase item status"

    fill_in "Color", with: @incase_item_status.color
    fill_in "Title", with: @incase_item_status.title
    click_on "Create Incase item status"

    assert_text "Incase item status was successfully created"
    click_on "Back"
  end

  test "should update Incase item status" do
    visit incase_item_status_url(@incase_item_status)
    click_on "Edit this incase item status", match: :first

    fill_in "Color", with: @incase_item_status.color
    fill_in "Title", with: @incase_item_status.title
    click_on "Update Incase item status"

    assert_text "Incase item status was successfully updated"
    click_on "Back"
  end

  test "should destroy Incase item status" do
    visit incase_item_status_url(@incase_item_status)
    click_on "Destroy this incase item status", match: :first

    assert_text "Incase item status was successfully destroyed"
  end
end
