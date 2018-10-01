class Teacher < ApplicationRecord
  AUTHENTICATION_TOKEN_EXPIRATION_DAYS = Rails.application.secrets.expiration_date_days
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, :first_name, :last_name, :personal_document_number, :birthdate, :phone_number,
            :address, presence: true
  validates :phone_number, numericality: true, length: { minimum: 8, maximum: 10 }
  validates :personal_document_number, numericality: true, length: { is: 8 }
  validates :email, uniqueness: { case_sensitive: false }

  has_many :teacher_courses, dependent: :destroy
  has_many :courses, through: :teacher_courses

  def authentication_token
    AuthenticationToken.generate_for(id, Time.zone.now + AUTHENTICATION_TOKEN_EXPIRATION_DAYS.days)
  end
end
