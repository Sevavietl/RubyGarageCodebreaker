module Codebreaker::Markers
  class PlusMinusMarker
    def mark(bulls, cows)
      '+' * bulls + '-' * cows
    end
  end
end
