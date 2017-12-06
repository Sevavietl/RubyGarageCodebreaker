module Codebreaker
  # Game of bulls and cows.
  class Game
    NUMBER_OF_ATTEMPTS = 7

    def initialize(storage: Storage::InMemoryStorage.new, matcher: Matcher.new)
      @storage = storage
      @matcher = matcher
    end

    def start
      generate_secret_code
      generate_hints
      matcher.secret_code = @secret_code
      @attempts_left = NUMBER_OF_ATTEMPTS
      @status = :in_progress
    end

    def attempts_available?
      return false if won? || lost?

      @attempts_left > 0 || lost
    end

    def guess(guess)
      raise Exceptions::NoAttemptsLeft unless attempts_available?
      @attempts_left -= 1
      matcher.match?(guess) && won
    end

    def marks
      matcher.marks
    end

    def hint
      @hints.shift
    end

    def won?
      @status == :won
    end

    def lost?
      @status == :lost
    end

    def in_progress?
      @status == :in_progress
    end

    def save(name)
      raise Exceptions::CannotSaveGameInProgress if in_progress?

      storage.save([name].concat(to_a))
    end

    def scores
      storage.to_a
    end

    private

    attr_accessor :storage, :matcher

    def generate_secret_code
      @secret_code = Array.new(4) { roll_dice }.join
    end

    def roll_dice
      rand(1..6)
    end

    def generate_hints
      @hints = @secret_code.split('').shuffle
    end

    def won
      @status = :won
      true
    end

    def lost
      @status = :lost
      false
    end

    def to_a
      [NUMBER_OF_ATTEMPTS - @attempts_left, @status.to_s]
    end
  end
end
