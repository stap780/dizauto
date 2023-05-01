require "application_system_test_case"

class DetalsTest < ApplicationSystemTestCase
  setup do
    @detal = detals(:one)
  end

  test "visiting the index" do
    visit detals_url
    assert_selector "h1", text: "Detals"
  end

  test "should create detal" do
    visit detals_url
    click_on "New detal"

    fill_in "Description", with: @detal.description
    fill_in "Sku", with: @detal.sku
    fill_in "Title", with: @detal.title
    click_on "Create Detal"

    assert_text "Detal was successfully created"
    click_on "Back"
  end

  test "should update Detal" do
    visit detal_url(@detal)
    click_on "Edit this detal", match: :first

    fill_in "Description", with: @detal.description
    fill_in "Sku", with: @detal.sku
    fill_in "Title", with: @detal.title
    click_on "Update Detal"

    assert_text "Detal was successfully updated"
    click_on "Back"
  end

  test "should destroy Detal" do
    visit detal_url(@detal)
    click_on "Destroy this detal", match: :first

    assert_text "Detal was successfully destroyed"
  end
end
