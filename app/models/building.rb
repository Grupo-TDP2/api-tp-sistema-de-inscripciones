class Building < ApplicationRecord
  validates :name, :address, :postal_code, :city, presence: true
  validates :name, uniqueness: { case_sensitive: false }

  has_many :classrooms, dependent: :destroy
end
