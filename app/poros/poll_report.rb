class PollReport
  def initialize(department_id, school_term_id)
    @department_id = department_id
    @school_term_id = school_term_id
  end

  def report
    courses = Course.from_department(@department_id).from_school_term(@school_term_id)
    courses.map do |course|
      {
        subject: course.subject.name, course: course.name, mean_rate: mean_rate(course),
        comments: poll_comments(course)
      }
    end
  end

  private

  def mean_rate(course)
    course.polls.sum(:rate).to_f / course.polls.size unless course.polls.size.zero?
  end

  def poll_comments(course)
    course.polls.map { |poll| { poll_id: poll.id, comment: poll.comment, date: poll.created_at } }
  end
end
