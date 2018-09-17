class Classroom < ApplicationRecord
  validates :floor, :number, presence: true
  validates :number, uniqueness: { scope: :floor, case_sensitive: false }

  belongs_to :building
end
