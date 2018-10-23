require 'rails_helper'

describe FinalExamWeek do
  before { create(:final_exam_week) }

  it { is_expected.to validate_presence_of(:date_start_week) }
  it { is_expected.to validate_presence_of(:year) }
  it { is_expected.to validate_uniqueness_of(:date_start_week).scoped_to(:year).case_insensitive }

  context 'when trying to create an exam week for another year' do
    let(:exam_week) do
      build(:final_exam_week, year: '2019', date_start_week: Date.new(2018, 12, 1).next_week)
    end

    it 'returns the right error' do
      exam_week.save
      expect(exam_week.errors.full_messages.last).to match(/must match the year set/)
    end
  end

  context 'when trying to create an exam week in a day other than Monday' do
    let(:exam_week) do
      build(:final_exam_week, date_start_week: Date.new(2018, 7, 1), year: '2018')
    end

    it 'returns the right error' do
      exam_week.save
      expect(exam_week.errors.full_messages.last).to match(/must be Monday/)
    end
  end

  context 'when trying to create an exam week in a wrong month' do
    let(:exam_week) do
      build(:final_exam_week, date_start_week: Date.new(2018, 5, 1), year: '2018')
    end

    it 'returns the right error' do
      exam_week.save
      expect(exam_week.errors.full_messages.last)
        .to match(/must be in February, July, August or December/)
    end
  end
end
