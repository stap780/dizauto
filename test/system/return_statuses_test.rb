require "application_system_test_case"

class ReturnStatusesTest < ApplicationSystemTestCase
  setup do
    @return_status = return_statuses(:one)
  end

  test "visiting the index" do
    visit return_statuses_url
    assert_selector "h1", text: "Return statuses"
  end

  test "should create return status" do
    visit return_statuses_url
    click_on "New return status"

    fill_in "Color", with: @return_status.color
    fill_in "Position", with: @return_status.position
    fill_in "Title", with: @return_status.title
    click_on "Create Return status"

    assert_text "Return status was successfully created"
    click_on "Back"
  end

  test "should update Return status" do
    visit return_status_url(@return_status)
    click_on "Edit this return status", match: :first

    fill_in "Color", with: @return_status.color
    fill_in "Position", with: @return_status.position
    fill_in "Title", with: @return_status.title
    click_on "Update Return status"

    assert_text "Return status was successfully updated"
    click_on "Back"
  end

  test "should destroy Return status" do
    visit return_status_url(@return_status)
    click_on "Destroy this return status", match: :first

    assert_text "Return status was successfully destroyed"
  end
end
