class ExamReminderWorker
  include Sidekiq::Worker
  FIREBASE_URL = 'https://fcm.googleapis.com/fcm/send'.freeze
  ACTION_MSG = 'unsubscribe_exam'.freeze

  def perform
    from = (Date.current + 3.days).beginning_of_day
    to = (Date.current + 3.days).end_of_day
    Exam.where(date_time: from..to).map do |exam|
      exam.students.each { |student| send_reminder(student, exam) }
    end
  end

  private

  def send_reminder(student, exam)
    message_content = {
      to: student.device_token.to_s,
      data: { title: 'Recordatorio de examen', body: reminder_message(exam), type: ACTION_MSG }
    }
    server_key = Rails.application.secrets.server_push_key
    HTTParty.post(FIREBASE_URL, body: message_content.to_json,
                                headers: { 'Content-Type' => 'application/json',
                                           'Authorization' => "key=#{server_key}" })
  end

  def reminder_message(exam)
    limit_date = exam.date_time - 2.days
    day = I18n.t("date.days.#{limit_date.strftime('%A').downcase}")
    "Si no vas a rendir #{exam.course.subject.name}, recuerda desinscribirte antes del día" \
    " #{day} a la hora #{limit_date.strftime('%H:%M')}."
  end
end
