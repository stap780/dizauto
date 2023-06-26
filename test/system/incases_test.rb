require "application_system_test_case"

class IncasesTest < ApplicationSystemTestCase
  setup do
    @incase = incases(:one)
  end

  test "visiting the index" do
    visit incases_url
    assert_selector "h1", text: "Incases"
  end

  test "should create incase" do
    visit incases_url
    click_on "New incase"

    fill_in "Carnumber", with: @incase.carnumber
    fill_in "Company", with: @incase.company_id
    fill_in "Date", with: @incase.date
    fill_in "Modelauto", with: @incase.modelauto
    fill_in "Region", with: @incase.region
    fill_in "Status", with: @incase.status
    fill_in "Stoanumber", with: @incase.stoanumber
    fill_in "Strah", with: @incase.strah_id
    fill_in "Tip", with: @incase.tip
    fill_in "Totalsum", with: @incase.totalsum
    fill_in "Unumber", with: @incase.unumber
    click_on "Create Incase"

    assert_text "Incase was successfully created"
    click_on "Back"
  end

  test "should update Incase" do
    visit incase_url(@incase)
    click_on "Edit this incase", match: :first

    fill_in "Carnumber", with: @incase.carnumber
    fill_in "Company", with: @incase.company_id
    fill_in "Date", with: @incase.date
    fill_in "Modelauto", with: @incase.modelauto
    fill_in "Region", with: @incase.region
    fill_in "Status", with: @incase.status
    fill_in "Stoanumber", with: @incase.stoanumber
    fill_in "Strah", with: @incase.strah_id
    fill_in "Tip", with: @incase.tip
    fill_in "Totalsum", with: @incase.totalsum
    fill_in "Unumber", with: @incase.unumber
    click_on "Update Incase"

    assert_text "Incase was successfully updated"
    click_on "Back"
  end

  test "should destroy Incase" do
    visit incase_url(@incase)
    click_on "Destroy this incase", match: :first

    assert_text "Incase was successfully destroyed"
  end
end
