require "application_system_test_case"

class EntersTest < ApplicationSystemTestCase
  setup do
    @enter = enters(:one)
  end

  test "visiting the index" do
    visit enters_url
    assert_selector "h1", text: "Enters"
  end

  test "should create enter" do
    visit enters_url
    click_on "New enter"

    fill_in "Date", with: @enter.date
    fill_in "Enter status", with: @enter.enter_status_id
    fill_in "Manager", with: @enter.manager_id
    fill_in "Title", with: @enter.title
    fill_in "Warehouse", with: @enter.warehouse_id
    click_on "Create Enter"

    assert_text "Enter was successfully created"
    click_on "Back"
  end

  test "should update Enter" do
    visit enter_url(@enter)
    click_on "Edit this enter", match: :first

    fill_in "Date", with: @enter.date
    fill_in "Enter status", with: @enter.enter_status_id
    fill_in "Manager", with: @enter.manager_id
    fill_in "Title", with: @enter.title
    fill_in "Warehouse", with: @enter.warehouse_id
    click_on "Update Enter"

    assert_text "Enter was successfully updated"
    click_on "Back"
  end

  test "should destroy Enter" do
    visit enter_url(@enter)
    click_on "Destroy this enter", match: :first

    assert_text "Enter was successfully destroyed"
  end
end
