require 'rails_helper'

describe SchoolTerm do
  before { create(:school_term) }

  it { is_expected.to validate_presence_of(:term) }
  it { is_expected.to validate_presence_of(:year) }
  it { is_expected.to validate_presence_of(:date_start) }
  it { is_expected.to validate_presence_of(:date_end) }

  context 'when inserting a date with a different year' do
    let(:start) { '2028-01-01' }
    let(:d_end) { '2019-07-07' }
    let(:year) { '2028' }
    let(:wront_school_term) { build(:school_term, date_start: start, date_end: d_end, year: year) }

    it 'does not create a school term' do
      expect { wront_school_term.save }.not_to change(described_class, :count)
    end
  end

  context 'when inserting a date start after date end' do
    let(:start) { '2028-08-01' }
    let(:d_end) { '2028-07-07' }
    let(:year) { '2028' }
    let(:wront_school_term) { build(:school_term, date_start: start, date_end: d_end, year: year) }

    it 'does not create a school term' do
      expect { wront_school_term.save }.not_to change(described_class, :count)
    end
  end
end
