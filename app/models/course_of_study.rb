class CourseOfStudy < ApplicationRecord
  validates :name, :required_credits, presence: true
  validates :required_credits, numericality: { only_integer: true, greater_than: 100,
                                               less_than_or_equal_to: 300 }
  has_many :subjects, dependent: :destroy
end
