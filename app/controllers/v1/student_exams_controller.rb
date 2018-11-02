module V1
  class StudentExamsController < ApplicationController
    serialization_scope :current_user
    before_action -> { authenticate_user!(['Student']) }, only: %i[create destroy show]
    before_action -> { authenticate_user!(%w[Student Admin DepartmentStaff Teacher]) },
                  only: %i[index]
    before_action -> { authenticate_user!(%w[Admin DepartmentStaff Teacher]) },
                  only: %i[csv_format]

    def index
      render json: student_exams,
             include: ['student', 'exam.classroom', 'exam.classroom.building', 'exam.course',
                       'exam.course.subject', 'exam.course.subject.department',
                       'exam.course.teacher_courses', 'exam.course.teacher_courses.teacher']
    end

    def show
      return no_permission unless student_exam.student == @current_user
      render json: student_exam
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

    def csv_format
      exam = Exam.find(params[:exam_id])
      send_data StudentExam.to_csv(exam),
                filename: "exam-of-#{exam.date_time.to_date}-" \
                          "#{exam.course.subject.name.unicode_normalize(:nfkd)
                                .encode('ASCII', replace: '')}"\
                           "-enrolments-#{Time.zone.today}.csv", format: 'csv'
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

    def student_exam
      StudentExam.find(params[:id])
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

    def no_permission
      render json: { error: 'Cannot see the student exam of another student' },
             status: :unprocessable_entity
    end
  end
end
