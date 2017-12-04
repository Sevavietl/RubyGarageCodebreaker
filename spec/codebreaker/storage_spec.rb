require 'spec_helper'
require 'tempfile'

module Codebreaker
  RSpec.describe Storage do
    describe '#initialize' do
      it 'accepts file name' do
        filename = 'scores.csv'
        storage = described_class.new(filename)

        expect(storage.instance_variable_get(:@filename)).to eq(filename)
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

      players = [
        {
          player_name: 'John Dow',
          number_of_attempts: '3',
          result: 'victory',
        },
        {
          player_name: 'Jane Dow',
          number_of_attempts: '5',
          result: 'defeat',
        },
      ]

      players.each.with_index do |player, index|
        it "saves player #{index + 1} score" do
          @storage.save(*player.values)
          expect(@file.read.chomp.split(',')).to eq(player.values)
        end
      end
    end

    describe '#to_a' do
      before(:each) do
        @file = Tempfile.new('scores')
        @storage = described_class.new(@file.path)
        @players = [
          {
            player_name: 'John Dow',
            number_of_attempts: '3',
            result: 'victory',
          },
          {
            player_name: 'Jane Dow',
            number_of_attempts: '5',
            result: 'defeat',
          },
        ]
        @players.each { |player| @storage.save(*player.values) }
      end

      after(:each) do
        @file.close
        @file.delete
      end

      it 'returns an array of all scores' do
        expect(@storage.to_a).to be_an(Array)
        expect(@storage.to_a).to eq(@players.map(&:values))
      end
    end
  end
end
