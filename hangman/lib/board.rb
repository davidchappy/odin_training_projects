class Board

  attr_accessor :guesses, :game

  def initialize(game)
    @game = game
  end

  def update
    divider
    puts "Word: #{@game.player_guesses[:letters].join(' ')}"
    puts "Misses: #{@game.player_guesses[:misses].join(', ')}"
    puts "#{$turn_limit - @game.current_turn} turns left."
    divider
  end

  def match_result(won=false)
    case won
    when false
      puts "Sorry, you weren't able to guess the word. Better luck next time!"
    when true
      puts "Congratulations - you guessed the word!"
    end
    @game.start_again
  end

  def divider
    puts "--------"
  end

end