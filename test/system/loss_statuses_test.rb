require "application_system_test_case"

class LossStatusesTest < ApplicationSystemTestCase
  setup do
    @loss_status = loss_statuses(:one)
  end

  test "visiting the index" do
    visit loss_statuses_url
    assert_selector "h1", text: "Loss statuses"
  end

  test "should create loss status" do
    visit loss_statuses_url
    click_on "New loss status"

    fill_in "Color", with: @loss_status.color
    fill_in "Position", with: @loss_status.position
    fill_in "Title", with: @loss_status.title
    click_on "Create Loss status"

    assert_text "Loss status was successfully created"
    click_on "Back"
  end

  test "should update Loss status" do
    visit loss_status_url(@loss_status)
    click_on "Edit this loss status", match: :first

    fill_in "Color", with: @loss_status.color
    fill_in "Position", with: @loss_status.position
    fill_in "Title", with: @loss_status.title
    click_on "Update Loss status"

    assert_text "Loss status was successfully updated"
    click_on "Back"
  end

  test "should destroy Loss status" do
    visit loss_status_url(@loss_status)
    click_on "Destroy this loss status", match: :first

    assert_text "Loss status was successfully destroyed"
  end
end
