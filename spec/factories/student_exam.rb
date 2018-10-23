FactoryBot.define do
  factory :student_exam do
    exam do
      school_term = create(:school_term, year: Date.current.year, term: SchoolTerm.current_term)
      course = create(:course, school_term: school_term)
      create(:exam, course: course)
    end
    student do
      date_start = exam.course.school_term.date_start
      Timecop.freeze(date_start - 4.days) do
        enrolment = create(:enrolment, course: exam.course, status: :approved,
                                       partial_qualification: 8)
        enrolment.student
      end
    end
  end
end
