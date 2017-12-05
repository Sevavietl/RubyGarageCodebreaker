module Codebreaker::Markers
  class ClassicalMarker
    def mark(bulls, cows)
      '%d Bulls, %d Cows' % [bulls, cows]
    end
  end
end
