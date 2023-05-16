require "application_system_test_case"

class CompaniesTest < ApplicationSystemTestCase
  setup do
    @company = companies(:one)
  end

  test "visiting the index" do
    visit companies_url
    assert_selector "h1", text: "Companies"
  end

  test "should create company" do
    visit companies_url
    click_on "New company"

    fill_in "Bank account", with: @company.bank_account
    fill_in "Bank title", with: @company.bank_title
    fill_in "Bik", with: @company.bik
    fill_in "Fact address", with: @company.fact_address
    fill_in "Inn", with: @company.inn
    fill_in "Kpp", with: @company.kpp
    fill_in "Ogrn", with: @company.ogrn
    fill_in "Okpo", with: @company.okpo
    fill_in "Title", with: @company.title
    fill_in "Ur address", with: @company.ur_address
    click_on "Create Company"

    assert_text "Company was successfully created"
    click_on "Back"
  end

  test "should update Company" do
    visit company_url(@company)
    click_on "Edit this company", match: :first

    fill_in "Bank account", with: @company.bank_account
    fill_in "Bank title", with: @company.bank_title
    fill_in "Bik", with: @company.bik
    fill_in "Fact address", with: @company.fact_address
    fill_in "Inn", with: @company.inn
    fill_in "Kpp", with: @company.kpp
    fill_in "Ogrn", with: @company.ogrn
    fill_in "Okpo", with: @company.okpo
    fill_in "Title", with: @company.title
    fill_in "Ur address", with: @company.ur_address
    click_on "Update Company"

    assert_text "Company was successfully updated"
    click_on "Back"
  end

  test "should destroy Company" do
    visit company_url(@company)
    click_on "Destroy this company", match: :first

    assert_text "Company was successfully destroyed"
  end
end
