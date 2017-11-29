require 'spec_helper'

module Codebreaker
  RSpec.describe Game do
    describe '#initialize' do
      it 'sets marker during initialization' do
        game = described_class.new

        expect(game.instance_variable_get(:@marker)).to be_a(Marker)
      end
    end

    describe '#start' do
      let(:game) { described_class.new }
      
      it 'generates secret code' do
        game.start
        expect(game.instance_variable_get(:@secret_code)).not_to be_empty
      end
      
      it 'saves 4 numbers secret code' do
        game.start
        expect(game.instance_variable_get(:@secret_code).size).to eq(4)
      end
      
      it 'saves secret code with numbers from 1 to 6' do
        game.start
        expect(game.instance_variable_get(:@secret_code)).to match(/[1-6]+/)
      end
      
      it 'passes generated secret code to the marker' do
        marker = instance_double(Marker)
        expect(marker).to receive(:secret_code=)
        game.instance_variable_set(:@marker, marker)
        game.start
      end
      
      it 'resets number of left attempts to 7' do
        game.start
        expect(game.instance_variable_get(:@attempts_left)).to eq(7)
      end

      it 'sets hints list' do
        game.start
        secret_code = game.instance_variable_get(:@secret_code).split('').sort
        hints = game.instance_variable_get(:@hints).sort

        expect(hints).to eq(secret_code)
      end
    end
    
    describe '#guess' do
      let(:game) { described_class.new }

      before do
        game.start
      end

      it 'passes down the guess to the marker to be matched' do
        guess = '1234'
        marker = instance_double(Marker)
        expect(marker).to receive(:match?).with(guess) { true }
        game.instance_variable_set(:@marker, marker)
        
        expect(game.guess(guess)).to eq(true)
      end
      
      it 'decreases number of attempts left' do
        game.guess('1234')
        expect(game.instance_variable_get(:@attempts_left)).to eq(6)
      end
      
      it 'throws an exception when there are no attempts left' do
        game.instance_variable_set(:@attempts_left, 0)
        expect { game.guess('1234') }.to raise_error(NoAttemptsLeft)
      end
    end

    describe '#marks' do
      let(:game) { described_class.new }

      it 'requests marks from marker' do
        marker = instance_double(Marker)
        expect(marker).to receive(:marks) { '++++' }
        game.instance_variable_set(:@marker, marker)
        
        expect(game.marks).to eq('++++')
      end
    end

    describe '#hint' do
      let(:game) { described_class.new }

      before do
        game.start
      end
      
      it 'provides a hint and reduces the list of hints' do
        secret_code = game.instance_variable_get(:@secret_code)

        expect(game.instance_variable_get(:@hints).size).to eq(4) 
        expect(secret_code.include?(game.hint)).to eq(true)
        expect(game.instance_variable_get(:@hints).size).to eq(3) 
      end
      
      it 'returns nil when there are no hints left' do
        game.instance_variable_set(:@hints, [])

        expect(game.hint).to eq(nil) 
      end
    end
  end
end
