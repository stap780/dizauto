require "test_helper"

class ClientCompaniesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @client_company = client_companies(:one)
  end

  test "should get index" do
    get client_companies_url
    assert_response :success
  end

  test "should get new" do
    get new_client_company_url
    assert_response :success
  end

  test "should create client_company" do
    assert_difference("ClientCompany.count") do
      post client_companies_url, params: {client_company: {client_id: @client_company.client_id, company_id: @client_company.company_id}}
    end

    assert_redirected_to client_company_url(ClientCompany.last)
  end

  test "should show client_company" do
    get client_company_url(@client_company)
    assert_response :success
  end

  test "should get edit" do
    get edit_client_company_url(@client_company)
    assert_response :success
  end

  test "should update client_company" do
    patch client_company_url(@client_company), params: {client_company: {client_id: @client_company.client_id, company_id: @client_company.company_id}}
    assert_redirected_to client_company_url(@client_company)
  end

  test "should destroy client_company" do
    assert_difference("ClientCompany.count", -1) do
      delete client_company_url(@client_company)
    end

    assert_redirected_to client_companies_url
  end
end
