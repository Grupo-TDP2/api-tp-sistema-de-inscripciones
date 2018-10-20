module V1
  class SubjectsController < ApplicationController
    before_action -> { authenticate_user!(%w[Student DepartmentStaff]) }, only: [:index]

    def index
      subjects = if @current_user.is_a? Student
                   course_of_study.subjects
                 else
                   @current_user.department.subjects
                 end
      render json: subjects, status: :ok
    end

    private

    def course_of_study
      @course_of_study ||= CourseOfStudy.find(params[:course_of_study_id])
    end
  end
end
