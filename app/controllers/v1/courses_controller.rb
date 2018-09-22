module V1
  class CoursesController < ApplicationController
    def index
      render json: subject.courses.current_school_term, status: :ok
    end

    private

    def subject
      @subject ||= Subject.find(params[:subject_id])
    end
  end
end
