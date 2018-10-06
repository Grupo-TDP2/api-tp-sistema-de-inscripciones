class DepartmentStaff < User
  self.table_name = 'department_staffs'
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, :department_id, presence: true
  validate :unique_email
  belongs_to :department

  def unique_email
    errors.add(:email, 'is already taken') if Teacher.exists?(email: email) ||
                                              Student.exists?(email: email) ||
                                              Admin.exists?(email: email)
  end
end
