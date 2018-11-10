class Teacher < User
  self.table_name = 'teachers'
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, :first_name, :last_name, :username, presence: true
  validates :email, uniqueness: { case_sensitive: false }

  has_many :teacher_courses, dependent: :destroy
  has_many :courses, through: :teacher_courses
end
