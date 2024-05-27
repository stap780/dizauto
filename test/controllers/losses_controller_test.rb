require "test_helper"

class LossesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @loss = losses(:one)
  end

  test "should get index" do
    get losses_url
    assert_response :success
  end

  test "should get new" do
    get new_loss_url
    assert_response :success
  end

  test "should create loss" do
    assert_difference("Loss.count") do
      post losses_url, params: { loss: { date: @loss.date, loss_status_id: @loss.loss_status_id, manager_id: @loss.manager_id, title: @loss.title, warehouse_id: @loss.warehouse_id } }
    end

    assert_redirected_to loss_url(Loss.last)
  end

  test "should show loss" do
    get loss_url(@loss)
    assert_response :success
  end

  test "should get edit" do
    get edit_loss_url(@loss)
    assert_response :success
  end

  test "should update loss" do
    patch loss_url(@loss), params: { loss: { date: @loss.date, loss_status_id: @loss.loss_status_id, manager_id: @loss.manager_id, title: @loss.title, warehouse_id: @loss.warehouse_id } }
    assert_redirected_to loss_url(@loss)
  end

  test "should destroy loss" do
    assert_difference("Loss.count", -1) do
      delete loss_url(@loss)
    end

    assert_redirected_to losses_url
  end
end
