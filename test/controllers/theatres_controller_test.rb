require "test_helper"

class TheatresControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get theatres_index_url
    assert_response :success
  end

  test "should get show" do
    get theatres_show_url
    assert_response :success
  end

  test "should get new" do
    get theatres_new_url
    assert_response :success
  end

  test "should get edit" do
    get theatres_edit_url
    assert_response :success
  end
end
