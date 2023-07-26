require "application_system_test_case"

class ClientCompaniesTest < ApplicationSystemTestCase
  setup do
    @client_company = client_companies(:one)
  end

  test "visiting the index" do
    visit client_companies_url
    assert_selector "h1", text: "Client companies"
  end

  test "should create client company" do
    visit client_companies_url
    click_on "New client company"

    fill_in "Client", with: @client_company.client_id
    fill_in "Company", with: @client_company.company_id
    click_on "Create Client company"

    assert_text "Client company was successfully created"
    click_on "Back"
  end

  test "should update Client company" do
    visit client_company_url(@client_company)
    click_on "Edit this client company", match: :first

    fill_in "Client", with: @client_company.client_id
    fill_in "Company", with: @client_company.company_id
    click_on "Update Client company"

    assert_text "Client company was successfully updated"
    click_on "Back"
  end

  test "should destroy Client company" do
    visit client_company_url(@client_company)
    click_on "Destroy this client company", match: :first

    assert_text "Client company was successfully destroyed"
  end
end
