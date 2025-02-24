require "test_helper"

class AvitosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @avito = avitos(:one)
  end

  test "should get index" do
    get avitos_url
    assert_response :success
  end

  test "should get new" do
    get new_avito_url
    assert_response :success
  end

  test "should create avito" do
    assert_difference("Avito.count") do
      post avitos_url, params: { avito: { api_id: @avito.api_id, api_secret: @avito.api_secret, title: @avito.title } }
    end

    assert_redirected_to avito_url(Avito.last)
  end

  test "should show avito" do
    get avito_url(@avito)
    assert_response :success
  end

  test "should get edit" do
    get edit_avito_url(@avito)
    assert_response :success
  end

  test "should update avito" do
    patch avito_url(@avito), params: { avito: { api_id: @avito.api_id, api_secret: @avito.api_secret, title: @avito.title } }
    assert_redirected_to avito_url(@avito)
  end

  test "should destroy avito" do
    assert_difference("Avito.count", -1) do
      delete avito_url(@avito)
    end

    assert_redirected_to avitos_url
  end
end
