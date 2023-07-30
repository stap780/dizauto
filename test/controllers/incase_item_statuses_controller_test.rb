require "test_helper"

class IncaseItemStatusesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @incase_item_status = incase_item_statuses(:one)
  end

  test "should get index" do
    get incase_item_statuses_url
    assert_response :success
  end

  test "should get new" do
    get new_incase_item_status_url
    assert_response :success
  end

  test "should create incase_item_status" do
    assert_difference("IncaseItemStatus.count") do
      post incase_item_statuses_url, params: { incase_item_status: { color: @incase_item_status.color, title: @incase_item_status.title } }
    end

    assert_redirected_to incase_item_status_url(IncaseItemStatus.last)
  end

  test "should show incase_item_status" do
    get incase_item_status_url(@incase_item_status)
    assert_response :success
  end

  test "should get edit" do
    get edit_incase_item_status_url(@incase_item_status)
    assert_response :success
  end

  test "should update incase_item_status" do
    patch incase_item_status_url(@incase_item_status), params: { incase_item_status: { color: @incase_item_status.color, title: @incase_item_status.title } }
    assert_redirected_to incase_item_status_url(@incase_item_status)
  end

  test "should destroy incase_item_status" do
    assert_difference("IncaseItemStatus.count", -1) do
      delete incase_item_status_url(@incase_item_status)
    end

    assert_redirected_to incase_item_statuses_url
  end
end
