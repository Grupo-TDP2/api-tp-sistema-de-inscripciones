module V1
  class CoursesController < ApplicationController
    skip_before_action :authenticate_user!, only: %i[index]

    def index
      render json: subject.courses.current_school_term, status: :ok
    end

    private

    def subject
      @subject ||= Subject.find(params[:subject_id])
    end
  end
end
