class Enrolment < ApplicationRecord
  self.inheritance_column = :_type_disabled # So that we can use the :type column
  validates :type, presence: true
  validate :valid_enrolment_date

  belongs_to :student
  belongs_to :course

  enum type: { normal: 0, conditional: 1 }

  def valid_enrolment_date
    errors.add(:created_at, 'must belong to some school term') if
      SchoolTerm.current_school_term.blank?
    errors.add(:created_at, 'cannot be less than 7 days before the next school term.') if
      SchoolTerm.current_school_term.date_start - 7.days < Time.current
  end
end
