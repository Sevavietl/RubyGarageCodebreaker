require 'spec_helper'

module Codebreaker
  RSpec.describe Marker do
    describe '#initialize' do
      it 'sets default marks' do
        marker = described_class.new
        
        expect(marker.instance_variable_get(:@correct_position_mark)).to eq('+')
        expect(marker.instance_variable_get(:@incorrect_position_mark)).to eq('-')
      end
      
      it 'accepts marks to be used in place of default ones' do
        marker = described_class.new('foo', 'bar')
        
        expect(marker.instance_variable_get(:@correct_position_mark)).to eq('foo')
        expect(marker.instance_variable_get(:@incorrect_position_mark)).to eq('bar')
      end
    end

    describe '#secret_code=' do
      let(:marker) { described_class.new }
      
      it 'accepts array secret code to match against' do
        marker.secret_code = ['1', '2', '3', '4']
        expect(marker.instance_variable_get(:@secret_code_hash))
          .to eq({ '1' => [0], '2' => [1], '3' => [2], '4' => [3] })
      end

      it 'accepts string secret code to match against' do
        marker.secret_code = '1234'
        expect(marker.instance_variable_get(:@secret_code_hash))
          .to eq({ '1' => [0], '2' => [1], '3' => [2], '4' => [3] })
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
