class SchoolTermUnsubscribeReminderWorker
  include Sidekiq::Worker
  FIREBASE_URL = 'https://fcm.googleapis.com/fcm/send'.freeze
  ACTION_MSG = 'unsubscribe_course'.freeze

  def perform
    return unless SchoolTerm.current_school_term.date_start == Date.current
    SchoolTerm.current_school_term.courses.map do |course|
      course.students.each { |student| send_reminder(student) }
    end
  end

  private

  def send_reminder(student)
    message_content = {
      to: student.device_token.to_s,
      data: { title: 'Desinscripción a materias', body: reminder_message, type: ACTION_MSG }
    }
    server_key = Rails.application.secrets.server_push_key
    HTTParty.post(FIREBASE_URL, body: message_content.to_json,
                                headers: { 'Content-Type' => 'application/json',
                                           'Authorization' => "key=#{server_key}" })
  end

  def reminder_message
    'Se ha abierto el período de desincripción a cursadas, si se ha anotado a una materia que' \
    ' no va a cursar recuerde desincribirse'
  end
end
