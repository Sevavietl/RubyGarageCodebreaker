require 'spec_helper'
require 'tempfile'

module Codebreaker
  module Storage
    RSpec.describe CsvStorage do
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
          storage = described_class.new(filename)

          expect(storage.send(:filename)).to eq(filename)
        end
      end

      describe '#save' do
        before(:each) do
          @file = Tempfile.new('scores')
          @storage = described_class.new(@file.path)
        end

        after(:each) do
          @file.close
          @file.delete
        end

        records.each.with_index do |record, index|
          it "saves record #{index + 1}" do
            @storage.save(record.values)
            expect(@file.read.chomp.split(',')).to eq(record.values)
          end
        end
      end

      describe '#to_a' do
        before(:each) do
          @file = Tempfile.new('scores')
          @storage = described_class.new(@file.path)
          records.each { |record| @storage.save(record.values) }
        end

        after(:each) do
          @file.close
          @file.delete
        end

        it 'returns an array of all scores' do
          expect(@storage.to_a).to be_an(Array)
          expect(@storage.to_a).to eq(records.map(&:values))
        end
      end
    end
  end
end
