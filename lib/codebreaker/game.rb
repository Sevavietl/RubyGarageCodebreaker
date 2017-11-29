module Codebreaker
  class Game
    NUMBER_OF_ATTEMPTS = 7

    def initialize
      @marker = Marker.new
    end

    def start
      @secret_code = 4.times.collect { roll_dice }.join
      @hints = @secret_code.split('').shuffle
      @marker.secret_code = @secret_code
      @attempts_left = NUMBER_OF_ATTEMPTS
    end

    def guess(guess)
      raise NoAttemptsLeft unless @attempts_left > 0
      @attempts_left -= 1
      @marker.match?(guess)
    end

    def marks
      @marker.marks
    end

    def hint
      @hints.shift
    end

    private

    def roll_dice
      rand(1..6)
    end
  end
end
