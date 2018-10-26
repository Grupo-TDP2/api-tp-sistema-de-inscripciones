require 'rails_helper'

describe V1::StudentExamsController do
  describe '#index' do
    let(:school_term) do
      SchoolTerm.find_by(year: Date.current.year, term: SchoolTerm.current_term).presence ||
        create(:school_term, year: Date.current.year, term: SchoolTerm.current_term)
    end
    let(:course) { create(:course, school_term: school_term, accept_free_condition_exam: false) }
    let(:exam) { create(:exam, course: course) }
    let(:student) do
      date_start = exam.course.school_term.date_start
      Timecop.freeze(date_start - 4.days) do
        enrolment = create(:enrolment, course: exam.course, status: :approved,
                                       partial_qualification: 8)
        enrolment.student
      end
    end

    let(:index_request) { get :index }

    context 'with no student logged in' do
      it 'returns unauthorized' do
        index_request
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'with a student logged in' do
      before { sign_in student }

      context 'with some exams' do
        before { create(:student_exam, student: student, exam: exam) }

        it 'returns 1 exam' do
          index_request
          expect(response_body.size).to eq 1
        end
      end
    end

    context 'with an admin logged in' do
      before { sign_in create(:admin) }
      let(:index_request) do
        get :index, params: {
          department_id: course.subject.department.id, course_id: course.id, exam_id: exam.id
        }
      end

      context 'with some exams' do
        before { create(:student_exam, student: student, exam: exam) }

        it 'returns 1 exam' do
          index_request
          expect(response_body.size).to eq 1
        end
      end
    end
  end

  describe '#create' do
    let!(:school_term) do
      create(:school_term, year: Date.current.year, term: SchoolTerm.current_term)
    end
    let(:student) { create(:student) }
    let(:course) { create(:course, school_term: school_term) }
    let(:exam) { create(:exam, course: course) }
    let(:create_request) do
      post :create, params: { student_exam: { exam_id: exam.id, condition: 'regular' } }
    end

    before do
      Timecop.freeze(school_term.date_start - 4.days) do
        create(:enrolment, student: student, course: course, status: :approved)
      end
    end

    context 'with no student logged in' do
      it 'returns unauthorized' do
        create_request
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'with a student logged in' do
      context 'when trying to enrol in less than 48 hs before the exam datetime' do
        before do
          Timecop.freeze(exam.date_time - 47.hours)
          sign_in student
        end

        it 'returns the right code' do
          create_request
          expect(response).to have_http_status :unprocessable_entity
        end

        it 'returns the right error' do
          create_request
          expect(response_body['error'])
            .to match(/Cannot enrol in an exam 48 hs before its datetime/)
        end
      end

      context 'when trying to enrol in 48 hs or more than the exam datetime' do
        before do
          Timecop.freeze(exam.date_time - 49.hours)
          sign_in student
        end

        it 'creates the student exam' do
          expect { create_request }.to change(StudentExam, :count)
        end
      end
    end
  end

  describe '#destroy' do
    let(:student_exam) { create(:student_exam) }

    let(:destroy_request) { delete :destroy, params: { id: student_exam.id } }

    context 'with no student logged in' do
      it 'returns unauthorized' do
        destroy_request
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'with a student logged in' do
      before { sign_in student_exam.student }

      it 'deletes the student exam' do
        expect { destroy_request }.to change(StudentExam, :count).by(-1)
      end
    end
  end

  describe '#csv_format' do
    let(:school_term) do
      SchoolTerm.find_by(year: Date.current.year, term: SchoolTerm.current_term).presence ||
        create(:school_term, year: Date.current.year, term: SchoolTerm.current_term)
    end
    let(:course) { create(:course, school_term: school_term, accept_free_condition_exam: false) }
    let(:exam) { create(:exam, course: course) }
    let(:csv_request) do
      get :csv_format, params: { teacher_id: 'me', course_id: course.id, exam_id: exam.id }
    end
    let(:student) do
      date_start = exam.course.school_term.date_start
      Timecop.freeze(date_start - 4.days) do
        enrolment = create(:enrolment, course: exam.course, status: :approved,
                                       partial_qualification: 8)
        enrolment.student
      end
    end

    before { create(:student_exam, student: student, exam: exam) }

    context 'with no user logged in' do
      it 'returns unauthorized' do
        csv_request
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'with a teacher logged in' do
      before { sign_in create(:teacher) }

      it 'returns the csv file with the right headers' do
        csv_request
        expect(CSV.parse(response.body).first).to match_array(%w[name registration_date condition])
      end

      it 'returns the csv file with the enrolled students' do
        csv_request
        registration = exam.student_exams.first
        expect(CSV.parse(response.body).last[0]).to eq "#{registration.student.last_name} "\
                                                       "#{registration.student.first_name}"
      end
    end

    context 'with an admin logged in' do
      let(:csv_request) do
        get :csv_format, params: { department_id: course.subject.department.id,
                                   course_id: course.id, exam_id: exam.id }
      end

      before { sign_in create(:admin) }

      it 'returns the csv file with the right headers' do
        csv_request
        expect(CSV.parse(response.body).first).to match_array(%w[name registration_date condition])
      end

      it 'returns the csv file with the enrolled students' do
        csv_request
        registration = exam.student_exams.first
        expect(CSV.parse(response.body).last[0]).to eq "#{registration.student.last_name} "\
                                                       "#{registration.student.first_name}"
      end
    end
  end
end
