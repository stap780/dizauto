require "test_helper"

class VarbindsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @varbind = varbinds(:one)
  end

  test "should get index" do
    get varbinds_url
    assert_response :success
  end

  test "should get new" do
    get new_varbind_url
    assert_response :success
  end

  test "should create varbind" do
    assert_difference("Varbind.count") do
      post varbinds_url, params: { varbind: { value: @varbind.value, varbindable_id: @varbind.varbindable_id, varbindable_type: @varbind.varbindable_type, variant_id: @varbind.variant_id } }
    end

    assert_redirected_to varbind_url(Varbind.last)
  end

  test "should show varbind" do
    get varbind_url(@varbind)
    assert_response :success
  end

  test "should get edit" do
    get edit_varbind_url(@varbind)
    assert_response :success
  end

  test "should update varbind" do
    patch varbind_url(@varbind), params: { varbind: { value: @varbind.value, varbindable_id: @varbind.varbindable_id, varbindable_type: @varbind.varbindable_type, variant_id: @varbind.variant_id } }
    assert_redirected_to varbind_url(@varbind)
  end

  test "should destroy varbind" do
    assert_difference("Varbind.count", -1) do
      delete varbind_url(@varbind)
    end

    assert_redirected_to varbinds_url
  end
end
