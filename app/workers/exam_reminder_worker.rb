class ExamReminderWorker
  include Sidekiq::Worker
  FIREBASE_URL = 'https://fcm.googleapis.com/fcm/send'.freeze

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
      notification: { title: 'Recordatorio de examen',
                      body: "Falta poco para el exámen de #{exam.course.subject.name}." }
    }
    server_key = Rails.application.secrets.server_push_key
    HTTParty.post(FIREBASE_URL, body: message_content.to_json,
                                headers: { 'Content-Type' => 'application/json',
                                           'Authorization' => "key=#{server_key}" })
  end
end
