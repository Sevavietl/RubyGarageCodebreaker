module Codebreaker
  class Application
    def run
      @game = Game.new
      @game.start

      loop do
        print 'Propose a guess: '
        
        begin
          case gets.strip
          when /^exit$/
            puts 'Thank you for the game!'
            break
          when /^hint$/
            puts @game.hint || 'Unfortunately you are out of hints... :('
          when /^([1-6]{4})$/
            if @game.guess($1)
              puts 'Congratulation! You have won!'
              break unless try_again
            else
              puts 'You are almost there! Please, try again.'
              puts @game.marks
            end
          else
            puts 'Cannot comprehend... :('
          end
        rescue NoAttemptsLeft
          puts 'Unfortinately you have lost...'
          break unless try_again
        end
      end
    end

    private

    def try_again(n = 2)
      print 'Do you want to play again? (Y/n):'
      input = gets.strip.downcase

      if ['', 'y', 'yes'].include?(input)
        @game.start || true
      elsif %w[n no].include?(input) || n <= 0
        (puts 'Thank you for the game!') && false
      else
        try_again(n - 1)
      end
    end
  end
end
