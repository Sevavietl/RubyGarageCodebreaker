module Codebreaker
  module Markers
    # Marker that will interpret the number of bulls
    # and cows in a codebreaker plus-minus style.
    class PlusMinusMarker
      def mark(bulls, cows)
        '+' * bulls + '-' * cows
      end
    end
  end
end
