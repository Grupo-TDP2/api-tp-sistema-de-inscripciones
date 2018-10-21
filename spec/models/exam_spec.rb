require 'rails_helper'

describe Exam do
  before { create(:exam) }

  it { is_expected.to validate_presence_of(:exam_type) }
  it { is_expected.to validate_presence_of(:date_time) }
  it { is_expected.to validate_presence_of(:final_exam_week_id) }
  it { is_expected.to validate_presence_of(:course_id) }

  it do
    is_expected
      .to validate_uniqueness_of(:final_exam_week_id).case_insensitive.scoped_to(:course_id)
  end

  context 'when creating an exam with hour lower than 8 in the morning' do
    let(:final_exam_week) { FinalExamWeek.last.presence || create(:final_exam_week) }
    let!(:school_term) do
      SchoolTerm.last.presence || create(:school_term, year: Date.current.year,
                                                       term: SchoolTerm.current_term)
    end
    let(:course) { create(:course, school_term: school_term) }
    let(:exam) do
      build(:exam, date_time: Time.zone.parse(final_exam_week.date_start_week.to_s) + 7.hours,
                   final_exam_week: final_exam_week, course: course)
    end

    it 'returns the right error' do
      exam.save
      expect(exam.errors.full_messages.last).to match(/cannot be in invalid hours/)
    end
  end

  context 'when creating an exam with hour higher than 21 in the evening' do
    let(:final_exam_week) { FinalExamWeek.last.presence || create(:final_exam_week) }
    let!(:school_term) do
      create(:school_term, year: Date.current.year, term: SchoolTerm.current_term)
    end
    let(:course) { create(:course, school_term: school_term) }
    let(:exam) do
      build(:exam, date_time: Time.zone.parse("#{final_exam_week.date_start_week} 21:30:00"),
                   final_exam_week: final_exam_week, course: course)
    end

    it 'returns the right error' do
      exam.save
      expect(exam.errors.full_messages.last).to match(/cannot be in invalid hours/)
    end
  end

  context 'when creating an exam in a week different than the final exam week it belongs' do
    let(:final_exam_week) { FinalExamWeek.last.presence || create(:final_exam_week) }
    let!(:school_term) do
      create(:school_term, year: Date.current.year, term: SchoolTerm.current_term)
    end
    let(:course) { create(:course, school_term: school_term) }
    let(:exam) do
      build(:exam, date_time: Time.zone.parse("#{final_exam_week.date_start_week + 2.weeks} \
                                               08:30"), course: course)
    end

    it 'returns the right error' do
      exam.save
      expect(exam.errors.full_messages.last)
        .to match(/cannot be in a different week than the final exam week it belongs/)
    end
  end
end
