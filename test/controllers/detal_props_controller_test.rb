require "test_helper"

class DetalPropsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @detal_prop = detal_props(:one)
  end

  test "should get index" do
    get detal_props_url
    assert_response :success
  end

  test "should get new" do
    get new_detal_prop_url
    assert_response :success
  end

  test "should create detal_prop" do
    assert_difference("DetalProp.count") do
      post detal_props_url, params: { detal_prop: { characteristic_id: @detal_prop.characteristic_id, property_id: @detal_prop.property_id } }
    end

    assert_redirected_to detal_prop_url(DetalProp.last)
  end

  test "should show detal_prop" do
    get detal_prop_url(@detal_prop)
    assert_response :success
  end

  test "should get edit" do
    get edit_detal_prop_url(@detal_prop)
    assert_response :success
  end

  test "should update detal_prop" do
    patch detal_prop_url(@detal_prop), params: { detal_prop: { characteristic_id: @detal_prop.characteristic_id, property_id: @detal_prop.property_id } }
    assert_redirected_to detal_prop_url(@detal_prop)
  end

  test "should destroy detal_prop" do
    assert_difference("DetalProp.count", -1) do
      delete detal_prop_url(@detal_prop)
    end

    assert_redirected_to detal_props_url
  end
end
