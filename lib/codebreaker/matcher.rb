module Codebreaker
  # Matching mechanism to determine the number
  # of bulls and cows in the guess.
  class Matcher
    def initialize(marker = Markers::PlusMinusMarker.new)
      @marker = marker
      @secret_code_hash = hash_with_default_array_value
    end

    def secret_code=(secret_code)
      @secret_code_hash = array_to_hash_of_positions(unify_code(secret_code))
    end

    def match?(guess)
      raise Exceptions::InvalidGuessFormat unless valid_code?(guess)

      match(array_to_hash_of_positions(unify_code(guess)))

      bulls == 4
    end

    def marks
      marker.mark(bulls, cows)
    end

    private

    attr_reader :marker, :secret_code_hash
    attr_reader :exact_matches, :all_matches, :bulls, :cows

    def valid_code?(code)
      code = code.join('') if code.is_a?(Array)

      code.match(/^[1-6]{4}$/)
    end

    def unify_code(code)
      code.is_a?(String) ? code.split('') : code
    end

    def array_to_hash_of_positions(array)
      array
        .each_with_object(hash_with_default_array_value)
        .with_index do |(digit, hash), position|
          hash[digit].push(position)
          hash
        end
    end

    def hash_with_default_array_value
      Hash.new { |h, digit| h[digit] = [] }
    end

    def match(guess_hash)
      @exact_matches = 0
      @all_matches = 0

      guess_hash.each do |digit, positions|
        next if digit_is_not_present_in_the_secret_code(digit)
        add_exact_matches(digit, positions)
        add_all_matches(digit, positions)
      end

      @bulls = exact_matches
      @cows = all_matches - exact_matches
    end

    def digit_is_not_present_in_the_secret_code(digit)
      secret_code_hash[digit].empty?
    end

    def add_exact_matches(digit, positions)
      @exact_matches += (secret_code_hash[digit] & positions).size
    end

    def add_all_matches(digit, positions)
      @all_matches += [secret_code_hash[digit], positions].min_by(&:size).size
    end
  end
end
