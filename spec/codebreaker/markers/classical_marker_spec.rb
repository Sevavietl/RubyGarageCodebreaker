require 'spec_helper'

module Codebreaker::Markers
  RSpec.describe ClassicalMarker do
    describe '#mark' do
      let(:marker) { described_class.new }

      it 'marks bulls and cows to "%d Bulls, %d Cows"' do
        expect(marker.mark(2, 2)).to eq('2 Bulls, 2 Cows')
      end
    end
  end
end
