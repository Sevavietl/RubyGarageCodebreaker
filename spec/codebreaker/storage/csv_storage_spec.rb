require 'spec_helper'
require 'tempfile'

RSpec.describe Codebreaker::Storage::CsvStorage do
  subject { described_class.new(file.path) }
  let(:file) { Tempfile.new('scores') }

  records = [
    {
      player_name: 'John Dow',
      number_of_attempts: '3',
      result: 'victory'
    },
    {
      player_name: 'Jane Dow',
      number_of_attempts: '5',
      result: 'defeat'
    }
  ]

  describe '#initialize' do
    it 'accepts file name' do
      filename = 'scores.csv'
      subject = described_class.new(filename)

      expect(subject.send(:filename)).to eq(filename)
    end
  end

  describe '#save' do
    after do
      file.close
      file.delete
    end

    records.each.with_index do |record, index|
      it "saves record #{index + 1}" do
        subject.save(record.values)
        expect(file.read.chomp.split(',')).to eq(record.values)
      end
    end
  end

  describe '#to_a' do
    before { records.each { |record| subject.save(record.values) } }

    after do
      file.close
      file.delete
    end

    it 'returns an array of all scores' do
      expect(subject.to_a).to be_an(Array)
      expect(subject.to_a).to eq(records.map(&:values))
    end
  end
end
