class Teacher < User
  self.table_name = 'teachers'
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, :first_name, :last_name, :username, :school_document_number, presence: true
  validates :email, uniqueness: { case_sensitive: false }
  validates :school_document_number, uniqueness: { case_sensitive: false }
  validates :school_document_number, numericality: true, length: { minimum: 7, maximum: 8 }

  has_many :teacher_courses, dependent: :destroy
  has_many :courses, through: :teacher_courses
end
