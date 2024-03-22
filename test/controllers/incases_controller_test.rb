require "test_helper"

class IncasesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @incase = incases(:one)
  end

  test "should get index" do
    get incases_url
    assert_response :success
  end

  test "should get new" do
    get new_incase_url
    assert_response :success
  end

  test "should create incase" do
    assert_difference("Incase.count") do
      post incases_url, params: {incase: {carnumber: @incase.carnumber, company_id: @incase.company_id, date: @incase.date, modelauto: @incase.modelauto, region: @incase.region, status: @incase.status, stoanumber: @incase.stoanumber, strah_id: @incase.strah_id, tip: @incase.tip, totalsum: @incase.totalsum, unumber: @incase.unumber}}
    end

    assert_redirected_to incase_url(Incase.last)
  end

  test "should show incase" do
    get incase_url(@incase)
    assert_response :success
  end

  test "should get edit" do
    get edit_incase_url(@incase)
    assert_response :success
  end

  test "should update incase" do
    patch incase_url(@incase), params: {incase: {carnumber: @incase.carnumber, company_id: @incase.company_id, date: @incase.date, modelauto: @incase.modelauto, region: @incase.region, status: @incase.status, stoanumber: @incase.stoanumber, strah_id: @incase.strah_id, tip: @incase.tip, totalsum: @incase.totalsum, unumber: @incase.unumber}}
    assert_redirected_to incase_url(@incase)
  end

  test "should destroy incase" do
    assert_difference("Incase.count", -1) do
      delete incase_url(@incase)
    end

    assert_redirected_to incases_url
  end
end
