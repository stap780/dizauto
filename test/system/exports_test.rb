require "application_system_test_case"

class ExportsTest < ApplicationSystemTestCase
  setup do
    @export = exports(:one)
  end

  test "visiting the index" do
    visit exports_url
    assert_selector "h1", text: "Exports"
  end

  test "should create export" do
    visit exports_url
    click_on "New export"

    fill_in "Format", with: @export.format
    fill_in "Link", with: @export.link
    fill_in "Template", with: @export.template
    fill_in "Time", with: @export.time
    fill_in "Title", with: @export.title
    click_on "Create Export"

    assert_text "Export was successfully created"
    click_on "Back"
  end

  test "should update Export" do
    visit export_url(@export)
    click_on "Edit this export", match: :first

    fill_in "Format", with: @export.format
    fill_in "Link", with: @export.link
    fill_in "Template", with: @export.template
    fill_in "Time", with: @export.time
    fill_in "Title", with: @export.title
    click_on "Update Export"

    assert_text "Export was successfully updated"
    click_on "Back"
  end

  test "should destroy Export" do
    visit export_url(@export)
    click_on "Destroy this export", match: :first

    assert_text "Export was successfully destroyed"
  end
end
