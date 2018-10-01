class Department < ApplicationRecord
  validates :name, :code, presence: true
  validates :code, numericality: true, length: { is: 2 }
  validates :name, uniqueness: { case_sensitive: false }
  validates :code, uniqueness: { case_sensitive: false }

  has_many :department_staffs, dependent: :destroy
  has_many :subjects, dependent: :destroy
end
