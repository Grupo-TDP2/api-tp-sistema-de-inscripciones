module V1
  class CourseOfStudiesController < ApplicationController
    def index
      render json: course_of_studies, status: :ok
    end

    private

    def course_of_studies
      CourseOfStudy.all
    end
  end
end
