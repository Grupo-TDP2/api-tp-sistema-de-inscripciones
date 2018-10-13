module V1
  class SubjectsController < ApplicationController
    before_action -> { authenticate_user!(['Student']) }, only: [:index]

    def index
      render json: course_of_study.subjects, status: :ok
    end

    private

    def course_of_study
      @course_of_study ||= CourseOfStudy.find(params[:course_of_study_id])
    end
  end
end
