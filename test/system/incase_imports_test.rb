require "application_system_test_case"

class IncaseImportsTest < ApplicationSystemTestCase
  setup do
    @incase_import = incase_imports(:one)
  end

  test "visiting the index" do
    visit incase_imports_url
    assert_selector "h1", text: "Incase imports"
  end

  test "should create incase import" do
    visit incase_imports_url
    click_on "New incase import"

    check "Active" if @incase_import.active
    fill_in "File", with: @incase_import.file
    fill_in "Report", with: @incase_import.report
    fill_in "Title", with: @incase_import.title
    fill_in "Uniq field", with: @incase_import.uniq_field
    click_on "Create Incase import"

    assert_text "Incase import was successfully created"
    click_on "Back"
  end

  test "should update Incase import" do
    visit incase_import_url(@incase_import)
    click_on "Edit this incase import", match: :first

    check "Active" if @incase_import.active
    fill_in "File", with: @incase_import.file
    fill_in "Report", with: @incase_import.report
    fill_in "Title", with: @incase_import.title
    fill_in "Uniq field", with: @incase_import.uniq_field
    click_on "Update Incase import"

    assert_text "Incase import was successfully updated"
    click_on "Back"
  end

  test "should destroy Incase import" do
    visit incase_import_url(@incase_import)
    click_on "Destroy this incase import", match: :first

    assert_text "Incase import was successfully destroyed"
  end
end
