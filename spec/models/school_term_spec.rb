require 'rails_helper'

describe SchoolTerm do
  before { create(:school_term) }

  it { is_expected.to validate_presence_of(:term) }
  it { is_expected.to validate_presence_of(:year) }
  it { is_expected.to validate_presence_of(:date_start) }
  it { is_expected.to validate_presence_of(:date_end) }

  context 'when inserting a date with a different year' do
    let(:start) { Date.new(2028, 1, 1) }
    let(:d_end) { Date.new(2019, 7, 7) }
    let(:year) { '2028' }
    let(:wrong_school_term) { build(:school_term, date_start: start, date_end: d_end, year: year) }

    it 'does not create a school term' do
      expect { wrong_school_term.save }.not_to change(described_class, :count)
    end
  end

  context 'when inserting a date start after date end' do
    let(:start) { Date.new(2028, 8, 1) }
    let(:d_end) { Date.new(2028, 7, 7) }
    let(:year) { '2028' }
    let(:wrong_school_term) { build(:school_term, date_start: start, date_end: d_end, year: year) }

    it 'does not create a school term' do
      expect { wrong_school_term.save }.not_to change(described_class, :count)
    end
  end

  context 'when inserting a wrong semester length' do
    let(:year) { '2028' }
    let(:wrong_school_term) do
      build(:school_term, date_start: start, date_end: d_end, year: year, term: term)
    end

    context 'with the first semester having more than 16 weeks' do
      let(:start) { Date.new(2028, 3, 1) }
      let(:d_end) { start + 17.weeks }
      let(:term) { :first_semester }

      it 'does not create a school term' do
        expect { wrong_school_term.save }.not_to change(described_class, :count)
      end

      it 'returns the right error' do
        wrong_school_term.save
        expect(wrong_school_term.errors.full_messages.first)
          .to match(/The semester must have 16 weeks/)
      end
    end

    context 'with the first semester having less than 16 weeks' do
      let(:start) { Date.new(2028, 3, 1) }
      let(:d_end) { start + 15.weeks }
      let(:term) { :first_semester }

      it 'does not create a school term' do
        expect { wrong_school_term.save }.not_to change(described_class, :count)
      end

      it 'returns the right error' do
        wrong_school_term.save
        expect(wrong_school_term.errors.full_messages.first)
          .to match(/The semester must have 16 weeks/)
      end
    end

    context 'with the second semester having more than 16 weeks' do
      let(:start) { Date.new(2028, 8, 1) }
      let(:d_end) { start + 17.weeks }
      let(:term) { :second_semester }

      it 'does not create a school term' do
        expect { wrong_school_term.save }.not_to change(described_class, :count)
      end

      it 'returns the right error' do
        wrong_school_term.save
        expect(wrong_school_term.errors.full_messages.first)
          .to match(/The semester must have 16 weeks/)
      end
    end

    context 'with the second semester having less than 16 weeks' do
      let(:start) { Date.new(2028, 8, 1) }
      let(:d_end) { start + 15.weeks }
      let(:term) { :second_semester }

      it 'does not create a school term' do
        expect { wrong_school_term.save }.not_to change(described_class, :count)
      end

      it 'returns the right error' do
        wrong_school_term.save
        expect(wrong_school_term.errors.full_messages.first)
          .to match(/The semester must have 16 weeks/)
      end
    end

    context 'with the summer school having more than 8 weeks' do
      let(:start) { Date.new(2028, 1, 1) }
      let(:d_end) { start + 9.weeks }
      let(:term) { :summer_school }

      it 'does not create a school term' do
        expect { wrong_school_term.save }.not_to change(described_class, :count)
      end

      it 'returns the right error' do
        wrong_school_term.save
        expect(wrong_school_term.errors.full_messages.first)
          .to match(/The semester must have 8 weeks/)
      end
    end

    context 'with the summer school having less than 8 weeks' do
      let(:start) { Date.new(2028, 1, 1) }
      let(:d_end) { start + 7.weeks }
      let(:term) { :summer_school }

      it 'does not create a school term' do
        expect { wrong_school_term.save }.not_to change(described_class, :count)
      end

      it 'returns the right error' do
        wrong_school_term.save
        expect(wrong_school_term.errors.full_messages.first)
          .to match(/The semester must have 8 weeks/)
      end
    end
  end

  context 'when inserting a school term in an incorrect month' do
    let(:year) { '2028' }
    let(:wrong_school_term) do
      build(:school_term, date_start: start, year: year, term: term)
    end

    context 'with the first semester starting in April' do
      let(:start) { Date.new(2028, 4, 1) }
      let(:term) { :first_semester }
      let(:d_end) { start + 16.weeks }

      it 'does not create a school term' do
        expect { wrong_school_term.save }.not_to change(described_class, :count)
      end

      it 'returns the right error' do
        wrong_school_term.save
        expect(wrong_school_term.errors.full_messages.last)
          .to match(/The semester must begin in month 3/)
      end
    end

    context 'with the second semester starting in July' do
      let(:start) { Date.new(2028, 7, 1) }
      let(:term) { :second_semester }
      let(:d_end) { start + 16.weeks }

      it 'does not create a school term' do
        expect { wrong_school_term.save }.not_to change(described_class, :count)
      end

      it 'returns the right error' do
        wrong_school_term.save
        expect(wrong_school_term.errors.full_messages.last)
          .to match(/The semester must begin in month 8/)
      end
    end

    context 'with the summer school starting in February' do
      let(:start) { Date.new(2028, 2, 1) }
      let(:d_end) { start + 8.weeks }
      let(:term) { :summer_school }

      it 'does not create a school term' do
        expect { wrong_school_term.save }.not_to change(described_class, :count)
      end

      it 'returns the right error' do
        wrong_school_term.save
        expect(wrong_school_term.errors.full_messages.last)
          .to match(/The semester must begin in month 1/)
      end
    end
  end
end
