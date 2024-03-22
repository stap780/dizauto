require "test_helper"

class IncaseTipsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @incase_tip = incase_tips(:one)
  end

  test "should get index" do
    get incase_tips_url
    assert_response :success
  end

  test "should get new" do
    get new_incase_tip_url
    assert_response :success
  end

  test "should create incase_tip" do
    assert_difference("IncaseTip.count") do
      post incase_tips_url, params: {incase_tip: {color: @incase_tip.color, title: @incase_tip.title}}
    end

    assert_redirected_to incase_tip_url(IncaseTip.last)
  end

  test "should show incase_tip" do
    get incase_tip_url(@incase_tip)
    assert_response :success
  end

  test "should get edit" do
    get edit_incase_tip_url(@incase_tip)
    assert_response :success
  end

  test "should update incase_tip" do
    patch incase_tip_url(@incase_tip), params: {incase_tip: {color: @incase_tip.color, title: @incase_tip.title}}
    assert_redirected_to incase_tip_url(@incase_tip)
  end

  test "should destroy incase_tip" do
    assert_difference("IncaseTip.count", -1) do
      delete incase_tip_url(@incase_tip)
    end

    assert_redirected_to incase_tips_url
  end
end
