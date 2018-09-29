module V1
  class CoursesController < ApplicationController
    skip_before_action :authenticate_user!, only: %i[index]

    def index
      render json: subject.courses.current_school_term,
             include: ['lesson_schedules', 'lesson_schedules.classroom',
                       'lesson_schedules.classroom.building', 'subject'], status: :ok
    end

    private

    def subject
      @subject ||= Subject.find(params[:subject_id])
    end
  end
end
