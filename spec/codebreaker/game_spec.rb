require 'spec_helper'

RSpec.describe Codebreaker::Game do
  subject { described_class.new }
  let(:matcher) { instance_double(Codebreaker::Matcher) }

  describe '#initialize' do
    it 'sets matcher during initialization' do
      expect(subject.instance_variable_get(:@matcher))
        .to be_a(Codebreaker::Matcher)
    end

    it 'sets storage during initialization (defaults to in memory storage)' do
      expect(subject.instance_variable_get(:@storage))
        .to be_a(Codebreaker::Storage::InMemoryStorage)
    end
  end

  describe '#start' do
    context 'with matcher in place' do
      before { subject.start }

      it 'generates secret code' do
        expect(subject.instance_variable_get(:@secret_code)).not_to be_empty
      end

      it 'saves 4 numbers secret code' do
        expect(subject.instance_variable_get(:@secret_code).size).to eq(4)
      end

      it 'saves secret code with numbers from 1 to 6' do
        expect(subject.instance_variable_get(:@secret_code)).to match(/[1-6]+/)
      end

      it 'resets number of left attempts to 7' do
        expect(subject.instance_variable_get(:@attempts_left)).to eq(7)
      end

      it 'sets hints list' do
        secret_code = subject.instance_variable_get(:@secret_code).split('')
        hints = subject.instance_variable_get(:@hints)

        expect(hints).to match_array(secret_code)
      end

      it 'sets game status in progress' do
        expect(subject.instance_variable_get(:@status)).to eq(:in_progress)
      end
    end

    it 'passes generated secret code to the matcher' do
      expect(matcher).to receive(:secret_code=)
      subject.instance_variable_set(:@matcher, matcher)
      subject.start
    end
  end

  describe '#attempts_available?' do
    before { subject.start }

    it 'returns true when there attempts left' do
      expect(subject.attempts_available?).to be_truthy
    end

    it 'returns false when there are no attempts left' do
      subject.instance_variable_set(:@attempts_left, 0)
      expect(subject.attempts_available?).to be_falsey
      expect(subject.lost?).to be_truthy
    end
  end

  describe '#guess' do
    before { subject.start }

    it 'passes down the guess to the matcher to be matched' do
      code = '1234'
      expect(matcher).to receive(:match?).with(code) { true }
      subject.instance_variable_set(:@matcher, matcher)

      expect(subject.guess(code)).to be_truthy
      expect(subject.won?).to be_truthy
    end

    it 'decreases number of attempts left' do
      subject.guess('1234')
      expect(subject.instance_variable_get(:@attempts_left)).to eq(6)
    end

    it 'throws an exception when there are no attempts left' do
      subject.instance_variable_set(:@attempts_left, 0)
      expect { subject.guess('1234') }
        .to raise_error(Codebreaker::Exceptions::NoAttemptsLeft)
      expect(subject.won?).to be_falsey
      expect(subject.lost?).to be_truthy
    end
  end

  describe '#marks' do
    it 'requests marks from matcher' do
      expect(matcher).to receive(:marks) { '++++' }
      subject.instance_variable_set(:@matcher, matcher)

      expect(subject.marks).to eq('++++')
    end
  end

  describe '#hint!' do
    before { subject.start }

    it 'provides a hint and reduces the list of hints' do
      secret_code = subject.instance_variable_get(:@secret_code)

      expect(subject.instance_variable_get(:@hints).size).to eq(4)
      expect(secret_code.include?(subject.hint!)).to be_truthy
      expect(subject.instance_variable_get(:@hints).size).to eq(3)
    end

    it 'returns nil when there are no hints left' do
      subject.instance_variable_set(:@hints, [])

      expect(subject.hint!).to be_nil
    end
  end

  describe '#save' do
    before { subject.start }

    it 'throws an exception when the game is in progress' do
      expect { subject.save('John Dow') }
        .to raise_error(Codebreaker::Exceptions::CannotSaveGameInProgress)
    end

    it 'saves players score (victory)' do
      subject.instance_variable_set(:@status, :won)
      subject.save('John Dow')
      expect(subject.scores).to include(['John Dow', 0, 'won'])
    end

    it 'saves players score (defeat)' do
      subject.instance_variable_set(:@attempts_left, 0)
      subject.instance_variable_set(:@status, :lost)
      subject.save('John Dow')
      expect(subject.scores).to include(['John Dow', 7, 'lost'])
    end
  end
end
