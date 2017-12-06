module Codebreaker
  module Markers
    # Marker that will interpret the number of bulls
    # and cows in classical way.
    class ClassicalMarker
      def mark(bulls, cows)
        format('%d Bulls, %d Cows', bulls, cows)
      end
    end
  end
end
