require 'spec_helper'

module Codebreaker
  RSpec.describe Game do
    describe '#initialize' do
      let(:game) { described_class.new }

      it 'sets matcher during initialization' do
        expect(game.instance_variable_get(:@matcher)).to be_a(Matcher)
      end
      
      it 'sets storage during initialization (defaults to in memory storage)' do
        expect(game.instance_variable_get(:@storage)).to be_a(Storage::InMemoryStorage)
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

      it 'passes generated secret code to the matcher' do
        matcher = instance_double(Matcher)
        expect(matcher).to receive(:secret_code=)
        game.instance_variable_set(:@matcher, matcher)
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
      
      it 'sets game status in progress' do
        game.start
        expect(game.instance_variable_get(:@status)).to eq(:in_progress)
      end
    end

    describe '#attempts_available?' do
      let(:game) { described_class.new }

      before do
        game.start
      end

      it 'returns true when there attempts left' do
        expect(game.attempts_available?).to eq(true)
      end

      it 'returns false when there are no attempts left and markes game as lost' do
        game.instance_variable_set(:@attempts_left, 0)
        expect(game.attempts_available?).to eq(false)
        expect(game.lost?).to eq(true)
      end
    end

    describe '#guess' do
      let(:game) { described_class.new }

      before do
        game.start
      end

      it 'passes down the guess to the matcher to be matched' do
        guess = '1234'
        matcher = instance_double(Matcher)
        expect(matcher).to receive(:match?).with(guess) { true }
        game.instance_variable_set(:@matcher, matcher)

        expect(game.guess(guess)).to eq(true)
        expect(game.won?).to eq(true)
      end

      it 'decreases number of attempts left' do
        game.guess('1234')
        expect(game.instance_variable_get(:@attempts_left)).to eq(6)
      end

      it 'throws an exception when there are no attempts left' do
        game.instance_variable_set(:@attempts_left, 0)
        expect { game.guess('1234') }.to raise_error(Exceptions::NoAttemptsLeft)
        expect(game.won?).to be(false)
        expect(game.lost?).to be(true)
      end
    end

    describe '#marks' do
      let(:game) { described_class.new }

      it 'requests marks from matcher' do
        matcher = instance_double(Matcher)
        expect(matcher).to receive(:marks) { '++++' }
        game.instance_variable_set(:@matcher, matcher)

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

    describe '#save' do
      let(:game) { described_class.new }

      before do
        game.start
      end

      it 'throws an exception when the game is in progress' do
        expect { game.save('John Dow') }.to raise_error(Exceptions::CannotSaveGameInProgress)
      end

      it 'saves players score with status and number of used attempts (won example)' do
        game.instance_variable_set(:@status, :won)
        game.save('John Dow')
        expect(game.scores).to include(['John Dow', 0, 'won'])
      end

      it 'saves players score with status and number of used attempts (lost example)' do
        game.instance_variable_set(:@attempts_left, 0)
        game.instance_variable_set(:@status, :lost)
        game.save('John Dow')
        expect(game.scores).to include(['John Dow', 7, 'lost'])
      end
    end
  end
end
