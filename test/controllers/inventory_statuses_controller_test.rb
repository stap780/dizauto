require "test_helper"

class InventoryStatusesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @inventory_status = inventory_statuses(:one)
  end

  test "should get index" do
    get inventory_statuses_url
    assert_response :success
  end

  test "should get new" do
    get new_inventory_status_url
    assert_response :success
  end

  test "should create inventory_status" do
    assert_difference("InventoryStatus.count") do
      post inventory_statuses_url, params: { inventory_status: { color: @inventory_status.color, position: @inventory_status.position, title: @inventory_status.title } }
    end

    assert_redirected_to inventory_status_url(InventoryStatus.last)
  end

  test "should show inventory_status" do
    get inventory_status_url(@inventory_status)
    assert_response :success
  end

  test "should get edit" do
    get edit_inventory_status_url(@inventory_status)
    assert_response :success
  end

  test "should update inventory_status" do
    patch inventory_status_url(@inventory_status), params: { inventory_status: { color: @inventory_status.color, position: @inventory_status.position, title: @inventory_status.title } }
    assert_redirected_to inventory_status_url(@inventory_status)
  end

  test "should destroy inventory_status" do
    assert_difference("InventoryStatus.count", -1) do
      delete inventory_status_url(@inventory_status)
    end

    assert_redirected_to inventory_statuses_url
  end
end
