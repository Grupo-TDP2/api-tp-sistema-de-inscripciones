class Enrolment < ApplicationRecord
  self.inheritance_column = :_type_disabled # So that we can use the :type column
  validates :type, :valid_enrolment_datetime, presence: true

  belongs_to :student
  belongs_to :course

  enum type: { normal: 0, conditional: 1 }
end
