module V1
  class DepartmentsController < ApplicationController
    before_action -> { authenticate_user!('DepartmentStaff') }, only: [:my_courses]

    def my_courses
      render json: @current_user.department.subjects,
             include: ['courses', 'courses.teachers', 'lesson_schedules.classroom',
                       'lesson_schedules.classroom.building', 'subject'], status: :ok
    end
  end
end
