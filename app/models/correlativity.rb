class Correlativity < ApplicationRecord
  belongs_to :subject
  belongs_to :correlative_subject, class_name: 'Subject'

  validate :correlative_to_self

  private

  def correlative_to_self
    return unless subject_id == correlative_subject_id
    errors.add :subject, 'A subject cannot be correlative to itself.'
  end
end
