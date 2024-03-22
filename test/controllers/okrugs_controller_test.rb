require "test_helper"

class OkrugsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @okrug = okrugs(:one)
  end

  test "should get index" do
    get okrugs_url
    assert_response :success
  end

  test "should get new" do
    get new_okrug_url
    assert_response :success
  end

  test "should create okrug" do
    assert_difference("Okrug.count") do
      post okrugs_url, params: {okrug: {title: @okrug.title}}
    end

    assert_redirected_to okrug_url(Okrug.last)
  end

  test "should show okrug" do
    get okrug_url(@okrug)
    assert_response :success
  end

  test "should get edit" do
    get edit_okrug_url(@okrug)
    assert_response :success
  end

  test "should update okrug" do
    patch okrug_url(@okrug), params: {okrug: {title: @okrug.title}}
    assert_redirected_to okrug_url(@okrug)
  end

  test "should destroy okrug" do
    assert_difference("Okrug.count", -1) do
      delete okrug_url(@okrug)
    end

    assert_redirected_to okrugs_url
  end
end
