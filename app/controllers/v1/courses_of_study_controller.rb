module V1
  class CoursesOfStudyController < ApplicationController
    def index
      render json: courses_of_study, status: :ok
    end

    private

    def courses_of_study
      @course_of_study ||= CourseOfStudy.all
    end
  end
end
