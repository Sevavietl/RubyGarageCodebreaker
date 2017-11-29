module Codebreaker
  class Marker
    attr_reader :marks

    def initialize(correct_position_mark = '+', incorrect_position_mark = '-')
      @correct_position_mark = correct_position_mark
      @incorrect_position_mark = incorrect_position_mark
      @secret_code_hash = hash_with_default_array_value
    end

    def secret_code=(secret_code)
      secret_code = unify_code(secret_code)
      @secret_code_hash = array_to_hash_of_positions(secret_code)
    end

    def match?(guess)
      mark(array_to_hash_of_positions(unify_code(guess)))
      @marks == @correct_position_mark * 4
    end

    private

    def unify_code(code)
      code.is_a?(String) ? code.split('') : code
    end

    def array_to_hash_of_positions(array)
      array.each.with_index
        .inject(hash_with_default_array_value) do |hash, (digit, position)|
          hash[digit].push(position)
          hash
        end
    end

    def hash_with_default_array_value
      Hash.new{ |h, digit| h[digit] = [] }
    end

    def mark(guess_hash)
      @marks = guess_hash.inject('') do |marks, (digit, positions)|
        positions_from_secret_code = @secret_code_hash[digit]

        unless positions_from_secret_code.empty?
          positions.each do |position|
            marks += if positions_from_secret_code.include?(position)
              @correct_position_mark
            else
              @incorrect_position_mark
            end
          end
        end        
        
        marks
      end
    end
  end
end
