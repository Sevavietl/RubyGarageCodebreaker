require 'spec_helper'

RSpec.describe Codebreaker::Storage::InMemoryStorage do
  let(:subject) { described_class.new }

  describe '#initialize' do
    it 'initializes empty data array for storing records' do
      expect(subject.send(:data)).to be_an(Array)
      expect(subject.send(:data).size).to eq(0)
    end
  end

  describe '#save' do
    it 'saves record' do
      record = {
        player_name: 'John Dow',
        number_of_attempts: '3',
        result: 'victory'
      }

      subject.save(record.values)

      expect(subject.send(:data)).to include(record.values)
    end
  end

  describe '#to_a' do
    it 'can be converted to an array' do
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

      records.map(&:values).each { |record| subject.save record }

      expect(subject.to_a).to be_an(Array)
      expect(subject.to_a).to eq(records.map(&:values))
    end
  end
end
