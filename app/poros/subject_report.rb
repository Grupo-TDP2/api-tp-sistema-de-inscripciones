class SubjectReport
  def initialize(department_id, school_term_id)
    @department_id = department_id
    @school_term_id = school_term_id
  end

  def report
    Subject.where(department_id: @department_id).map do |subject|
      subject_report = { subject: subject.name, teachers: 0, enrolments: 0, courses: [] }
      subject.courses.from_school_term(@school_term_id).map do |course|
        course_data = { course: course.name, enrolments: course.enrolments.size,
                        vacancies: course.vacancies, teachers: course.teachers }
        subject_report[:courses] << course_data
      end
      aggregate_data(subject_report)
    end
  end

  private

  def aggregate_data(subject_report)
    subject_report[:enrolments] = count_enrolments(subject_report)
    subject_report[:teachers] = count_unique_teachers(subject_report)
    subject_report
  end

  def count_enrolments(subject_report)
    subject_report[:courses].sum { |course| course[:enrolments] }
  end

  def count_unique_teachers(subject_report)
    teachers = []
    subject_report[:courses].each { |course| teachers << course[:teachers] }
    teachers.flatten.uniq.size
  end
end
