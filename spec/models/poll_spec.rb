require 'rails_helper'

describe Poll do
  context 'when the student has approved the course' do
    let!(:enrolment) do
      enrolment = build(:enrolment, status: :approved)
      enrolment.save(validate: false)
      enrolment
    end

    before { create(:poll, student: enrolment.student, course: enrolment.course) }

    it { is_expected.to validate_presence_of(:rate) }
    it { is_expected.to validate_presence_of(:comment) }
    it { is_expected.to validate_presence_of(:student_id) }
    it { is_expected.to validate_presence_of(:course_id) }

    it do
      is_expected.to validate_uniqueness_of(:student_id).case_insensitive.scoped_to(:course_id)
    end

    it { is_expected.to validate_numericality_of(:rate).only_integer }
    it { is_expected.to validate_numericality_of(:rate).is_less_than_or_equal_to(5) }
    it { is_expected.to validate_numericality_of(:rate).is_greater_than_or_equal_to(0) }
  end

  context 'when creating a poll for a course that the student has not approved' do
    let!(:enrolment) do
      enrolment = build(:enrolment, status: :not_evaluated)
      enrolment.save(validate: false)
      enrolment
    end

    let(:poll) { build(:poll, student: enrolment.student, course: enrolment.course) }

    it 'returns the right error' do
      poll.save
      expect(poll.errors.full_messages.last).to match(/must have approved the course/)
    end
  end
end
