require 'test_helper'

class HitsControllerTest < ActionController::TestCase
  test "should get ranking" do
    get :ranking
    assert_response :success
  end

end
