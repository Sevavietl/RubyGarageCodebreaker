require 'spec_helper'

RSpec.describe Codebreaker::Markers::PlusMinusMarker do
  subject { described_class.new }

  describe '#mark' do
    it 'marks bulls and cows to pluses and minuses' do
      expect(subject.mark(2, 2)).to eq('++--')
    end
  end
end
