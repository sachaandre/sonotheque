require "test_helper"

class PlayerControllerTest < ActionDispatch::IntegrationTest
  test "should get album" do
    get player_album_url
    assert_response :success
  end
end
