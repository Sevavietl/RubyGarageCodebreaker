require 'spec_helper'

RSpec.describe Codebreaker::Markers::ClassicalMarker do
  subject { described_class.new }

  describe '#mark' do
    it 'marks bulls and cows to "%d Bulls, %d Cows"' do
      expect(subject.mark(2, 2)).to eq('2 Bulls, 2 Cows')
    end
  end
end
