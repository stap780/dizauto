require "test_helper"

class MitupaisControllerTest < ActionDispatch::IntegrationTest
  setup do
    @mitupai = mitupais(:one)
  end

  test "should get index" do
    get mitupais_url
    assert_response :success
  end

  test "should get new" do
    get new_mitupai_url
    assert_response :success
  end

  test "should create mitupai" do
    assert_difference("Mitupai.count") do
      post mitupais_url, params: { mitupai: { api_key: @mitupai.api_key, api_url: @mitupai.api_url } }
    end

    assert_redirected_to mitupai_url(Mitupai.last)
  end

  test "should show mitupai" do
    get mitupai_url(@mitupai)
    assert_response :success
  end

  test "should get edit" do
    get edit_mitupai_url(@mitupai)
    assert_response :success
  end

  test "should update mitupai" do
    patch mitupai_url(@mitupai), params: { mitupai: { api_key: @mitupai.api_key, api_url: @mitupai.api_url } }
    assert_redirected_to mitupai_url(@mitupai)
  end

  test "should destroy mitupai" do
    assert_difference("Mitupai.count", -1) do
      delete mitupai_url(@mitupai)
    end

    assert_redirected_to mitupais_url
  end
end
