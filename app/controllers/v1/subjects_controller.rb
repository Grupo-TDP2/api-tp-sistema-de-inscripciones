module V1
  class SubjectsController < ApplicationController
    before_action -> { authenticate_user!(%w[Admin DepartmentStaff Student]) }, only: [:index]

    def index
      subjects = if @current_user.is_a? Student
                   course_of_study.subjects
                 elsif @current_user.is_a? Admin
                   Department.find(params[:department_id]).subjects
                 else
                   @current_user.department.subjects
                 end
      render json: subjects,
             include: ['courses', 'courses.teacher_courses', 'courses.teacher_courses.teacher',
                       'courses.lesson_schedules.classroom',
                       'courses.lesson_schedules.classroom.building', 'subject']
    end

    private

    def course_of_study
      @course_of_study ||= CourseOfStudy.find(params[:course_of_study_id])
    end
  end
end
