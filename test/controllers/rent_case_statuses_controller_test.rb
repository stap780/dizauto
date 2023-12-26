require "test_helper"

class RentCaseStatusesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @rent_case_status = rent_case_statuses(:one)
  end

  test "should get index" do
    get rent_case_statuses_url
    assert_response :success
  end

  test "should get new" do
    get new_rent_case_status_url
    assert_response :success
  end

  test "should create rent_case_status" do
    assert_difference("RentCaseStatus.count") do
      post rent_case_statuses_url, params: { rent_case_status: { color: @rent_case_status.color, position: @rent_case_status.position, title: @rent_case_status.title } }
    end

    assert_redirected_to rent_case_status_url(RentCaseStatus.last)
  end

  test "should show rent_case_status" do
    get rent_case_status_url(@rent_case_status)
    assert_response :success
  end

  test "should get edit" do
    get edit_rent_case_status_url(@rent_case_status)
    assert_response :success
  end

  test "should update rent_case_status" do
    patch rent_case_status_url(@rent_case_status), params: { rent_case_status: { color: @rent_case_status.color, position: @rent_case_status.position, title: @rent_case_status.title } }
    assert_redirected_to rent_case_status_url(@rent_case_status)
  end

  test "should destroy rent_case_status" do
    assert_difference("RentCaseStatus.count", -1) do
      delete rent_case_status_url(@rent_case_status)
    end

    assert_redirected_to rent_case_statuses_url
  end
end
