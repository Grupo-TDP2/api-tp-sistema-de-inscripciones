class Teacher < User
  self.table_name = 'teachers'
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, :first_name, :last_name, :personal_document_number, :birthdate, :phone_number,
            :address, presence: true
  validates :phone_number, numericality: true, length: { minimum: 8, maximum: 10 }
  validates :personal_document_number, numericality: true, length: { is: 8 }
  validates :email, uniqueness: { case_sensitive: false }
  validate :unique_email

  has_many :teacher_courses, dependent: :destroy
  has_many :courses, through: :teacher_courses

  def unique_email
    errors.add(:email, 'is already taken') if Student.exists?(email: email) ||
                                              DepartmentStaff.exists?(email: email) ||
                                              Admin.exists?(email: email)
  end
end
