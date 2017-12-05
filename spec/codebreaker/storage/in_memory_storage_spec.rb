require 'spec_helper'

module Codebreaker::Storage
  RSpec.describe InMemoryStorage do
    describe '#initialize' do
      let(:storage) { described_class.new }

      it 'initializes empty data array for storing records' do
        expect(storage.send :data).to be_an(Array)
        expect((storage.send :data).size).to eq(0)
      end
    end

    describe '#save' do
      let(:storage) { described_class.new }

      it 'saves record' do
        record = {
          player_name: 'John Dow',
          number_of_attempts: '3',
          result: 'victory',
        }
        
        storage.save(record.values)
        
        expect(storage.send :data).to include(record.values)
      end
    end
    
    describe '#to_a' do
      let(:storage) { described_class.new }

      it 'can be converted to an array' do
        records = [
          {
            player_name: 'John Dow',
            number_of_attempts: '3',
            result: 'victory',
          },
          {
            player_name: 'Jane Dow',
            number_of_attempts: '5',
            result: 'defeat',
          }
        ]

        records.map(&:values).each { |record| storage.save record }

        expect(storage.to_a).to be_an(Array)
        expect(storage.to_a).to eq(records.map(&:values))
      end
    end
  end
end
