require "test_helper"

class IncaseImportsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @incase_import = incase_imports(:one)
  end

  test "should get index" do
    get incase_imports_url
    assert_response :success
  end

  test "should get new" do
    get new_incase_import_url
    assert_response :success
  end

  test "should create incase_import" do
    assert_difference("IncaseImport.count") do
      post incase_imports_url, params: { incase_import: { active: @incase_import.active, file: @incase_import.file, report: @incase_import.report, title: @incase_import.title, uniq_field: @incase_import.uniq_field } }
    end

    assert_redirected_to incase_import_url(IncaseImport.last)
  end

  test "should show incase_import" do
    get incase_import_url(@incase_import)
    assert_response :success
  end

  test "should get edit" do
    get edit_incase_import_url(@incase_import)
    assert_response :success
  end

  test "should update incase_import" do
    patch incase_import_url(@incase_import), params: { incase_import: { active: @incase_import.active, file: @incase_import.file, report: @incase_import.report, title: @incase_import.title, uniq_field: @incase_import.uniq_field } }
    assert_redirected_to incase_import_url(@incase_import)
  end

  test "should destroy incase_import" do
    assert_difference("IncaseImport.count", -1) do
      delete incase_import_url(@incase_import)
    end

    assert_redirected_to incase_imports_url
  end
end
