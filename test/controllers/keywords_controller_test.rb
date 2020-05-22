require 'test_helper'

class KeywordsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get keywords_show_url
    assert_response :success
  end

end
