require "test_helper"

class IncaseStatusesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @incase_status = incase_statuses(:one)
  end

  test "should get index" do
    get incase_statuses_url
    assert_response :success
  end

  test "should get new" do
    get new_incase_status_url
    assert_response :success
  end

  test "should create incase_status" do
    assert_difference("IncaseStatus.count") do
      post incase_statuses_url, params: { incase_status: { color: @incase_status.color, title: @incase_status.title } }
    end

    assert_redirected_to incase_status_url(IncaseStatus.last)
  end

  test "should show incase_status" do
    get incase_status_url(@incase_status)
    assert_response :success
  end

  test "should get edit" do
    get edit_incase_status_url(@incase_status)
    assert_response :success
  end

  test "should update incase_status" do
    patch incase_status_url(@incase_status), params: { incase_status: { color: @incase_status.color, title: @incase_status.title } }
    assert_redirected_to incase_status_url(@incase_status)
  end

  test "should destroy incase_status" do
    assert_difference("IncaseStatus.count", -1) do
      delete incase_status_url(@incase_status)
    end

    assert_redirected_to incase_statuses_url
  end
end
