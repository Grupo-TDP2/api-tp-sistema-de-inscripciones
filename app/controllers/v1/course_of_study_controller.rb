class CoursesOfStudyController < ApplicationController
  def index
    render json: course_of_study
  end
end
