require "test_helper"

class EnterStatusesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @enter_status = enter_statuses(:one)
  end

  test "should get index" do
    get enter_statuses_url
    assert_response :success
  end

  test "should get new" do
    get new_enter_status_url
    assert_response :success
  end

  test "should create enter_status" do
    assert_difference("EnterStatus.count") do
      post enter_statuses_url, params: { enter_status: { color: @enter_status.color, position: @enter_status.position, title: @enter_status.title } }
    end

    assert_redirected_to enter_status_url(EnterStatus.last)
  end

  test "should show enter_status" do
    get enter_status_url(@enter_status)
    assert_response :success
  end

  test "should get edit" do
    get edit_enter_status_url(@enter_status)
    assert_response :success
  end

  test "should update enter_status" do
    patch enter_status_url(@enter_status), params: { enter_status: { color: @enter_status.color, position: @enter_status.position, title: @enter_status.title } }
    assert_redirected_to enter_status_url(@enter_status)
  end

  test "should destroy enter_status" do
    assert_difference("EnterStatus.count", -1) do
      delete enter_status_url(@enter_status)
    end

    assert_redirected_to enter_statuses_url
  end
end
