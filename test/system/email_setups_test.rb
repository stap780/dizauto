require "application_system_test_case"

class EmailSetupsTest < ApplicationSystemTestCase
  setup do
    @email_setup = email_setups(:one)
  end

  test "visiting the index" do
    visit email_setups_url
    assert_selector "h1", text: "Email setups"
  end

  test "should create email setup" do
    visit email_setups_url
    click_on "New email setup"

    fill_in "Address", with: @email_setup.address
    fill_in "Authentication", with: @email_setup.authentication
    fill_in "Domain", with: @email_setup.domain
    fill_in "Port", with: @email_setup.port
    check "Tls" if @email_setup.tls
    fill_in "User name", with: @email_setup.user_name
    fill_in "User password", with: @email_setup.user_password
    click_on "Create Email setup"

    assert_text "Email setup was successfully created"
    click_on "Back"
  end

  test "should update Email setup" do
    visit email_setup_url(@email_setup)
    click_on "Edit this email setup", match: :first

    fill_in "Address", with: @email_setup.address
    fill_in "Authentication", with: @email_setup.authentication
    fill_in "Domain", with: @email_setup.domain
    fill_in "Port", with: @email_setup.port
    check "Tls" if @email_setup.tls
    fill_in "User name", with: @email_setup.user_name
    fill_in "User password", with: @email_setup.user_password
    click_on "Update Email setup"

    assert_text "Email setup was successfully updated"
    click_on "Back"
  end

  test "should destroy Email setup" do
    visit email_setup_url(@email_setup)
    click_on "Destroy this email setup", match: :first

    assert_text "Email setup was successfully destroyed"
  end
end
