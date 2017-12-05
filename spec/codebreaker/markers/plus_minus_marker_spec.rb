require 'spec_helper'

module Codebreaker
  module Markers
    RSpec.describe PlusMinusMarker do
      describe '#mark' do
        let(:marker) { described_class.new }

        it 'marks bulls and cows to pluses and minuses' do
          expect(marker.mark(2, 2)).to eq('++--')
        end
      end
    end
  end
end
