require 'spec_helper'

RSpec.describe Codebreaker::Matcher do
  let(:subject) { described_class.new }

  describe '#initialize' do
    context 'with default marker' do
      it 'sets default marker' do
        expect(subject.send(:marker))
          .to be_a(Codebreaker::Markers::PlusMinusMarker)
      end

      it 'sets empty secret code hash' do
        expect(subject.send(:secret_code_hash)).to be_a(Hash)
        expect(subject.send(:secret_code_hash).size).to eq(0)
      end
    end

    it 'accepts marker to be used in place of default one' do
      matcher = described_class.new(Codebreaker::Markers::ClassicalMarker.new)

      expect(matcher.send(:marker))
        .to be_a(Codebreaker::Markers::ClassicalMarker)
    end
  end

  describe '#secret_code=' do
    let(:matcher) { described_class.new }

    it 'accepts array secret code to match against' do
      matcher.secret_code = %w[1 2 3 4]
      expect(matcher.send(:secret_code_hash))
        .to eq('1' => [0], '2' => [1], '3' => [2], '4' => [3])
    end

    it 'accepts string secret code to match against' do
      matcher.secret_code = '1234'
      expect(matcher.send(:secret_code_hash))
        .to eq('1' => [0], '2' => [1], '3' => [2], '4' => [3])
    end
  end

  describe '#match?' do
    before { subject.secret_code = '1234' }

    it 'returns true if secret code is matched' do
      expect(subject.match?('1234')).to eq(true)
    end

    it 'returns false if secret code is not matched' do
      expect(subject.match?('4321')).to eq(false)
    end

    invalid_guesses = %w[123 12345 foo]

    invalid_guesses.each do |invalid_guess|
      it "raises an exception on '#{invalid_guess}'" do
        expect { subject.match?(invalid_guess) }
          .to raise_error(Codebreaker::Exceptions::InvalidGuessFormat)
      end
    end
  end

  describe '#marks' do
    codes_to_marks = {
      '1234' => '++++',
      '5555' => '',
      '1235' => '+++',
      '5123' => '---',
      '1253' => '++-'
    }

    before { subject.secret_code = '1234' }

    codes_to_marks.each do |code, marks|
      it "returns '#{marks}' for '#{code}'" do
        subject.match?(code)
        expect(subject.marks).to eq(marks)
      end
    end
  end
end
