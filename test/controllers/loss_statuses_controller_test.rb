require "test_helper"

class LossStatusesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @loss_status = loss_statuses(:one)
  end

  test "should get index" do
    get loss_statuses_url
    assert_response :success
  end

  test "should get new" do
    get new_loss_status_url
    assert_response :success
  end

  test "should create loss_status" do
    assert_difference("LossStatus.count") do
      post loss_statuses_url, params: { loss_status: { color: @loss_status.color, position: @loss_status.position, title: @loss_status.title } }
    end

    assert_redirected_to loss_status_url(LossStatus.last)
  end

  test "should show loss_status" do
    get loss_status_url(@loss_status)
    assert_response :success
  end

  test "should get edit" do
    get edit_loss_status_url(@loss_status)
    assert_response :success
  end

  test "should update loss_status" do
    patch loss_status_url(@loss_status), params: { loss_status: { color: @loss_status.color, position: @loss_status.position, title: @loss_status.title } }
    assert_redirected_to loss_status_url(@loss_status)
  end

  test "should destroy loss_status" do
    assert_difference("LossStatus.count", -1) do
      delete loss_status_url(@loss_status)
    end

    assert_redirected_to loss_statuses_url
  end
end
