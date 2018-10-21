module V1
  class SubjectsController < ApplicationController
    before_action -> { authenticate_user!(%w[Admin DepartmentStaff Student]) }, only: [:index]

    def index
      subjects = source.present? ? source.subjects : @current_user.department.subjects
      render json: subjects,
             include: ['courses', 'courses.teacher_courses', 'courses.teacher_courses.teacher',
                       'courses.lesson_schedules.classroom', 'department',
                       'courses.lesson_schedules.classroom.building', 'subject']
    end

    private

    def source
      if params[:department_id]
        department
      elsif params[:course_of_study_id]
        course_of_study
      end
    end

    def department
      @department ||= Department.find(params[:department_id])
    end

    def course_of_study
      @course_of_study ||= CourseOfStudy.find(params[:course_of_study_id])
    end
  end
end
