module V1
  class TeachersController < ApplicationController
    before_action -> { authenticate_user!('Teacher') }, only: [:my_courses]

    def index
      render json: Teacher.all, status: :ok
    end

    def my_courses
      render json: current_user.courses.current_school_term,
             include: ['lesson_schedules', 'lesson_schedules.classroom',
                       'lesson_schedules.classroom.building', 'subject', 'school_term',
                       'teachers'], status: :ok
    end
  end
end
