require "application_system_test_case"

class InvoiceStatusesTest < ApplicationSystemTestCase
  setup do
    @invoice_status = invoice_statuses(:one)
  end

  test "visiting the index" do
    visit invoice_statuses_url
    assert_selector "h1", text: "Invoice statuses"
  end

  test "should create invoice status" do
    visit invoice_statuses_url
    click_on "New invoice status"

    fill_in "Color", with: @invoice_status.color
    fill_in "Position", with: @invoice_status.position
    fill_in "Title", with: @invoice_status.title
    click_on "Create Invoice status"

    assert_text "Invoice status was successfully created"
    click_on "Back"
  end

  test "should update Invoice status" do
    visit invoice_status_url(@invoice_status)
    click_on "Edit this invoice status", match: :first

    fill_in "Color", with: @invoice_status.color
    fill_in "Position", with: @invoice_status.position
    fill_in "Title", with: @invoice_status.title
    click_on "Update Invoice status"

    assert_text "Invoice status was successfully updated"
    click_on "Back"
  end

  test "should destroy Invoice status" do
    visit invoice_status_url(@invoice_status)
    click_on "Destroy this invoice status", match: :first

    assert_text "Invoice status was successfully destroyed"
  end
end
