require "test_helper"

class SupplyStatusesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @supply_status = supply_statuses(:one)
  end

  test "should get index" do
    get supply_statuses_url
    assert_response :success
  end

  test "should get new" do
    get new_supply_status_url
    assert_response :success
  end

  test "should create supply_status" do
    assert_difference("SupplyStatus.count") do
      post supply_statuses_url, params: {supply_status: {color: @supply_status.color, position: @supply_status.position, title: @supply_status.title}}
    end

    assert_redirected_to supply_status_url(SupplyStatus.last)
  end

  test "should show supply_status" do
    get supply_status_url(@supply_status)
    assert_response :success
  end

  test "should get edit" do
    get edit_supply_status_url(@supply_status)
    assert_response :success
  end

  test "should update supply_status" do
    patch supply_status_url(@supply_status), params: {supply_status: {color: @supply_status.color, position: @supply_status.position, title: @supply_status.title}}
    assert_redirected_to supply_status_url(@supply_status)
  end

  test "should destroy supply_status" do
    assert_difference("SupplyStatus.count", -1) do
      delete supply_status_url(@supply_status)
    end

    assert_redirected_to supply_statuses_url
  end
end
