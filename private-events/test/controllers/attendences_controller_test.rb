require 'test_helper'

class AttendencesControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get attendences_create_url
    assert_response :success
  end

end
