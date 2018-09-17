class Subject < ApplicationRecord
  validates :name, :code, :credits, presence: true
  validates :code, numericality: true, length: { is: 2 }
  validates :credits, numericality: { only_integer: true, greater_than: 0,
                                      less_than_or_equal_to: 10 }
  validates :name, uniqueness: { case_sensitive: false }
  validates :code, uniqueness: { case_sensitive: false }

  # Correlatives
  # Forward correlativity
  has_many :correlativities, dependent: :destroy
  has_many :correlative_subjects, through: :correlativities

  # Backward correlativity
  has_many :backward_correlativities, foreign_key: :correlative_subject_id,
                                      class_name: 'Correlativity', inverse_of: :correlativities,
                                      dependent: :destroy
  has_many :needed_subjects, through: :backward_correlativities, source: :subject
  belongs_to :department
  has_many :courses, dependent: :destroy
end
