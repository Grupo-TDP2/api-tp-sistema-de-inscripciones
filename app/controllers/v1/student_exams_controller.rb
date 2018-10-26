module V1
  class StudentExamsController < ApplicationController
    before_action -> { authenticate_user!(['Student']) }, only: %i[create destroy]
    before_action -> { authenticate_user!(%w[Student Admin DepartmentStaff Teacher]) },
                  only: %i[index]

    def index
      render json: student_exams,
             include: ['student', 'exam.classroom', 'exam.classroom.building', 'exam.course',
                       'exam.course.subject', 'exam.course.subject.department',
                       'exam.course.teacher_courses', 'exam.course.teacher_courses.teacher']
    end

    def create
      return invalid_date if close_to_exam_date?
      student_exam = StudentExam.new(student_exam_params.merge(student_id: @current_user.id))
      if student_exam.save
        render json: student_exam, status: :created
      else
        render json: { error: student_exam.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def destroy
      return invalid_date if close_to_exam_date?
      if StudentExam.find(params[:id]).delete
        head :ok
      else
        head :unprocessable_entity
      end
    end

    private

    def student_exam_params
      params.require(:student_exam).permit(:exam_id, :condition)
    end

    def student_exams
      if @current_user.is_a? Student
        @current_user.student_exams
      elsif params[:exam_id].present?
        Exam.find(params[:exam_id]).student_exams
      end
    end

    def close_to_exam_date?
      Time.current > exam.date_time - 2.days
    end

    def exam
      if params[:student_exam].present?
        Exam.find(student_exam_params[:exam_id])
      else
        StudentExam.find(params[:id]).exam
      end
    end

    def invalid_date
      render json: { error: 'Cannot enrol in an exam 48 hs before its datetime' },
             status: :unprocessable_entity
    end
  end
end
