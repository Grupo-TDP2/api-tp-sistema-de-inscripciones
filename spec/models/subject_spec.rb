require 'rails_helper'

describe Subject do
  let!(:subject) { create(:subject) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:code) }
  it { is_expected.to validate_presence_of(:credits) }

  it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
  it { is_expected.to validate_uniqueness_of(:code).case_insensitive }

  it { is_expected.to validate_numericality_of(:credits).only_integer }
  it { is_expected.to validate_numericality_of(:credits).is_less_than_or_equal_to(10) }
  it { is_expected.to validate_numericality_of(:credits).is_greater_than(0) }

  context 'when adding correlatives' do
    let!(:another_subject) { create(:subject, department: subject.department) }

    before { another_subject.correlative_subjects << described_class.first }

    it 'has a correlative_subject' do
      expect(another_subject.correlative_subjects.size).to eq 1
    end

    it 'adds the inverse correlativity' do
      expect(described_class.first.needed_subjects.first).to eq another_subject
    end
  end
end
