require "test_helper"

class AuditoriumsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get auditoriums_index_url
    assert_response :success
  end

  test "should get show" do
    get auditoriums_show_url
    assert_response :success
  end

  test "should get new" do
    get auditoriums_new_url
    assert_response :success
  end

  test "should get edit" do
    get auditoriums_edit_url
    assert_response :success
  end
end
