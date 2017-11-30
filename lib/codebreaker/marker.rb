module Codebreaker
  class Marker
    attr_reader :marks

    def initialize(correct_position_mark = '+', incorrect_position_mark = '-')
      @position_marks = {
        correct: correct_position_mark,
        incorrect: incorrect_position_mark
      }
      
      @secret_code_hash = hash_with_default_array_value
    end

    def secret_code=(secret_code)
      @secret_code_hash = [secret_code]
                          .map(&method(:unify_code))
                          .map(&method(:array_to_hash_of_positions))
                          .shift
    end

    def match?(guess)
      [guess]
        .map(&method(:unify_code))
        .map(&method(:array_to_hash_of_positions))
        .map(&method(:mark))

      @marks == @position_marks[:correct] * 4
    end

    private

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

    def mark(guess_hash)
      bulls_count = 0
      cows_count = 0
      guess_hash.each do |digit, positions|
        next unless digit_is_present_in_the_secret_code(digit)
        bulls = bulls(digit, positions)
        bulls_count += bulls.size
        cows_count += cows(digit, positions, bulls).size
      end

      @marks = map_bulls_and_cows(bulls_count, cows_count)
    end

    def digit_is_present_in_the_secret_code(digit)
      !@secret_code_hash[digit].empty?
    end

    def bulls(digit, positions)
      @secret_code_hash[digit] & positions
    end

    def cows(digit, positions, bulls)
      [@secret_code_hash[digit], positions]
        .map { |array| array - bulls }
        .min_by(&:size)
    end

    def map_bulls_and_cows(bulls, cows)
      @position_marks
        .values
        .zip([bulls, cows])
        .map { |mark, count| mark * count }
        .join
    end
  end
end
