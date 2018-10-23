class DepartmentStaff < User
  self.table_name = 'department_staffs'
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, :department_id, presence: true
  belongs_to :department
end
