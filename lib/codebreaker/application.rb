module Codebreaker
  class Application
    def run
      @game = Game.new
      @game.start

      loop do
        if !@game.attempts_available?
          break unless try_again
        end
        
        print 'Propose a guess: '

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
            puts @game.marks
          end
        when /^scores$/
          @game.scores.each { |score| puts 'Name: %s, Attempts: %d, Result: %s' % score }
        else
          puts 'Cannot comprehend... :('
        end
      end
    end

    private

    def try_again(n = 2)
      print 'Do you want to play again? (Y/n/s):'
      input = gets.strip.downcase

      if ['', 'y', 'yes'].include?(input)
        @game.start || true
      elsif %w[n no].include?(input) || n <= 0
        (puts 'Thank you for the game!') && false
      elsif %w[s save].include?(input)
        print 'Please, enter your name: '
        @game.save(gets.strip)
        try_again(n - 1)
      else
        try_again(n - 1)
      end
    end
  end
end
