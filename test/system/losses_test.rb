require "application_system_test_case"

class LossesTest < ApplicationSystemTestCase
  setup do
    @loss = losses(:one)
  end

  test "visiting the index" do
    visit losses_url
    assert_selector "h1", text: "Losses"
  end

  test "should create loss" do
    visit losses_url
    click_on "New loss"

    fill_in "Date", with: @loss.date
    fill_in "Loss status", with: @loss.loss_status_id
    fill_in "Manager", with: @loss.manager_id
    fill_in "Title", with: @loss.title
    fill_in "Warehouse", with: @loss.warehouse_id
    click_on "Create Loss"

    assert_text "Loss was successfully created"
    click_on "Back"
  end

  test "should update Loss" do
    visit loss_url(@loss)
    click_on "Edit this loss", match: :first

    fill_in "Date", with: @loss.date
    fill_in "Loss status", with: @loss.loss_status_id
    fill_in "Manager", with: @loss.manager_id
    fill_in "Title", with: @loss.title
    fill_in "Warehouse", with: @loss.warehouse_id
    click_on "Update Loss"

    assert_text "Loss was successfully updated"
    click_on "Back"
  end

  test "should destroy Loss" do
    visit loss_url(@loss)
    click_on "Destroy this loss", match: :first

    assert_text "Loss was successfully destroyed"
  end
end
