module V1
  class StudentExamsController < ApplicationController
    before_action -> { authenticate_user!(['Student']) }, only: %i[index create]

    def index
      render json: @current_user.exams, status: :ok
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

    private

    def student_exam_params
      params.require(:student_exam).permit(:exam_id, :condition)
    end

    def close_to_exam_date?
      exam = Exam.find(student_exam_params[:exam_id])
      Time.current > exam.date_time - 2.days
    end

    def invalid_date
      render json: { error: 'Cannot enrol in an exam 48 hs before its datetime' },
             status: :unprocessable_entity
    end
  end
end
