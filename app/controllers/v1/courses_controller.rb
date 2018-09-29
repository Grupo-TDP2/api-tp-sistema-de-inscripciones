module V1
  class CoursesController < ApplicationController
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
