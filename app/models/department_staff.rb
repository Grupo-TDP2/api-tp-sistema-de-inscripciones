class DepartmentStaff < ApplicationRecord
  AUTHENTICATION_TOKEN_EXPIRATION_DAYS = Rails.application.secrets.expiration_date_days
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, :department_id, presence: true
  belongs_to :department

  def authentication_token
    AuthenticationToken.generate_for(id, Time.zone.now + AUTHENTICATION_TOKEN_EXPIRATION_DAYS.days)
  end
end
