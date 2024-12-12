require "test_helper"

class PlreportsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get plreports_index_url
    assert_response :success
  end
end
