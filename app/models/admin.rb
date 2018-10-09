
class Admin < User
  AUTHENTICATION_TOKEN_EXPIRATION_DAYS = Rails.application.secrets.expiration_date_days
  self.table_name = 'admins'
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validate :unique_email

  def authentication_token
    AuthenticationToken.generate_for(id, Time.zone.now + AUTHENTICATION_TOKEN_EXPIRATION_DAYS.days)
  end

  def unique_email
    errors.add(:email, 'is already taken') if Teacher.exists?(email: email) ||
                                              DepartmentStaff.exists?(email: email) ||
                                              Student.exists?(email: email)
  end
end
