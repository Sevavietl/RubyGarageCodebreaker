require 'spec_helper'

RSpec.shared_examples 'a storage' do
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

  describe '#save' do
    it 'saves record' do
      record = records.first.values

      subject.save(record)

      expect(subject.to_a).to include(record)
    end
  end

  describe '#to_a' do
    it 'can be converted to an array' do
      records.map(&:values).each { |record| subject.save record }

      expect(subject.to_a).to eq(records.map(&:values))
    end
  end
end
