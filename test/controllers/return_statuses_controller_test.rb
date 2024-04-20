require "test_helper"

class ReturnStatusesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @return_status = return_statuses(:one)
  end

  test "should get index" do
    get return_statuses_url
    assert_response :success
  end

  test "should get new" do
    get new_return_status_url
    assert_response :success
  end

  test "should create return_status" do
    assert_difference("ReturnStatus.count") do
      post return_statuses_url, params: { return_status: { color: @return_status.color, position: @return_status.position, title: @return_status.title } }
    end

    assert_redirected_to return_status_url(ReturnStatus.last)
  end

  test "should show return_status" do
    get return_status_url(@return_status)
    assert_response :success
  end

  test "should get edit" do
    get edit_return_status_url(@return_status)
    assert_response :success
  end

  test "should update return_status" do
    patch return_status_url(@return_status), params: { return_status: { color: @return_status.color, position: @return_status.position, title: @return_status.title } }
    assert_redirected_to return_status_url(@return_status)
  end

  test "should destroy return_status" do
    assert_difference("ReturnStatus.count", -1) do
      delete return_status_url(@return_status)
    end

    assert_redirected_to return_statuses_url
  end
end
