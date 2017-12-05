require 'spec_helper'

module Codebreaker
  RSpec.describe Matcher do
    describe '#initialize' do
      it 'sets default marker' do
        matcher = described_class.new

        expect(matcher.send(:marker)).to be_a(Markers::PlusMinusMarker)
      end

      it 'accepts marker to be used in place of default one' do
        matcher = described_class.new(Markers::ClassicalMarker.new)

        expect(matcher.send(:marker)).to be_a(Markers::ClassicalMarker)
      end

      it 'sets empty secret code hash' do
        matcher = described_class.new

        expect(matcher.send(:secret_code_hash)).to be_a(Hash)
        expect(matcher.send(:secret_code_hash).size).to eq(0)
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
      let(:marker) { described_class.new }

      before do
        marker.secret_code = '1234'
      end

      it 'returns true if secret code is matched' do
        expect(marker.match?('1234')).to eq(true)
      end

      it 'returns false if secret code is not matched' do
        expect(marker.match?('4321')).to eq(false)
      end
    end

    describe '#marks' do
      let(:marker) { described_class.new }

      before do
        marker.secret_code = '1234'
      end

      it 'returns "++++" for completely matched code' do
        marker.match?('1234')
        expect(marker.marks).to eq('++++')
      end

      it 'returns empty string for code with no matches at all' do
        marker.match?('5555')
        expect(marker.marks).to eq('')
      end

      it 'properly marks matches' do
        marker.match?('1235')
        expect(marker.marks).to eq('+++')

        marker.match?('5123')
        expect(marker.marks).to eq('---')

        marker.match?('1253')
        expect(marker.marks).to eq('++-')
      end
    end
  end
end
