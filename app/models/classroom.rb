class Classroom < ApplicationRecord
  validates :floor, :number, presence: true
  validates :number, uniqueness: { scope: :floor, case_sensitive: false }

  belongs_to :building
  has_many :lesson_schedules, dependent: :destroy
end
