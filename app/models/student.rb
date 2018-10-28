class Student < User
  self.table_name = 'students'
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :email, :first_name, :last_name, :school_document_number, :username, :priority,
            presence: true
  validates :priority, numericality: { only_integer: true, greater_than: 0,
                                       less_than_or_equal_to: 100 }
  validates :school_document_number, numericality: true, length: { minimum: 5, maximum: 6 }
  validates :email, uniqueness: { case_sensitive: false }
  validate :unique_email

  has_many :enrolments, dependent: :destroy
  has_many :courses, through: :enrolments

  has_many :student_exams, dependent: :destroy
  has_many :exams, through: :student_exams

  def unique_email
    errors.add(:email, 'is already taken') if Teacher.exists?(email: email) ||
                                              DepartmentStaff.exists?(email: email) ||
                                              Admin.exists?(email: email)
  end

  def approved_subjects
    enrolments.where('final_qualification >= 4').map do |approved_enrolment|
      {
        subject: approved_enrolment.course.subject,
        department: approved_enrolment.course.subject.department,
        enrolment: approved_enrolment,
        school_term: approved_enrolment.course.school_term
      }
    end
  end
end
