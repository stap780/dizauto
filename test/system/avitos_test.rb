require "application_system_test_case"

class AvitosTest < ApplicationSystemTestCase
  setup do
    @avito = avitos(:one)
  end

  test "visiting the index" do
    visit avitos_url
    assert_selector "h1", text: "Avitos"
  end

  test "should create avito" do
    visit avitos_url
    click_on "New avito"

    fill_in "Api", with: @avito.api_id
    fill_in "Api secret", with: @avito.api_secret
    fill_in "Title", with: @avito.title
    click_on "Create Avito"

    assert_text "Avito was successfully created"
    click_on "Back"
  end

  test "should update Avito" do
    visit avito_url(@avito)
    click_on "Edit this avito", match: :first

    fill_in "Api", with: @avito.api_id
    fill_in "Api secret", with: @avito.api_secret
    fill_in "Title", with: @avito.title
    click_on "Update Avito"

    assert_text "Avito was successfully updated"
    click_on "Back"
  end

  test "should destroy Avito" do
    visit avito_url(@avito)
    click_on "Destroy this avito", match: :first

    assert_text "Avito was successfully destroyed"
  end
end
