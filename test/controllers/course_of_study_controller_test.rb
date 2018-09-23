require 'test_helper'

class CourseOfStudyControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get course_of_study_index_url
    assert_response :success
  end

end
