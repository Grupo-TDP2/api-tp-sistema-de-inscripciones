module V1
  class CoursesController < ApplicationController
    before_action -> { authenticate_user!('DepartmentStaff') }

    def index
      render json: subject.courses.current_school_term, status: :ok
    end

    def associate_teacher

    end

    private

    def subject
      @subject ||= Subject.find(params[:subject_id])
    end
  end
end
