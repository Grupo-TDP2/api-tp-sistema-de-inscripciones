require 'rails_helper'
describe LessonSchedule do
  before { create(:lesson_schedule) }
  it { is_expected.to validate_presence_of(:type) }
  it { is_expected.to validate_presence_of(:day) }
  it { is_expected.to validate_presence_of(:hour_start) }
  it { is_expected.to validate_presence_of(:hour_end) }
  context 'when inserting an hour start after an hour end' do
    let(:start) { '12:00' }
    let(:h_end) { '10:00' }
    let(:wrong_lesson_schedule) { build(:lesson_schedule, hour_start: start, hour_end: h_end) }

    it 'does not create a lesson schedule' do
      expect { wrong_lesson_schedule.save }.not_to change(described_class, :count)
    end
  end
end
