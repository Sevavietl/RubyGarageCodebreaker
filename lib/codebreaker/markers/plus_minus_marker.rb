module Codebreaker
  module Markers
    class PlusMinusMarker
      def mark(bulls, cows)
        '+' * bulls + '-' * cows
      end
    end
  end
end
