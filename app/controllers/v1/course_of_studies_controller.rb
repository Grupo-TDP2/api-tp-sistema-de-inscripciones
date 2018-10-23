module V1
  class CourseOfStudiesController < ApplicationController
    before_action -> { authenticate_user!(%w[Admin Student]) }, only: [:index]

    def index
      render json: course_of_studies, status: :ok
    end

    private

    def course_of_studies
      CourseOfStudy.all
    end
  end
end
