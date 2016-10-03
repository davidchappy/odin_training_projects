class Board

  attr_accessor :game

  def initialize(game)
    @game = game
  end

  def display_saves(saves)
    if saves == nil || saves == []
      puts "You have no saved games."
      puts "Exiting game."
      exit
    else
      puts "Your saves:"
      saves.each do |save|
        puts "(" + save[:id].to_s + ")" + " - " + Time.at(save[:time]).strftime("%Y-%m-%d %H:%M:%S")
      end
      divider
    end
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
      puts "The word was: #{@game.word}"
    when true
      puts "Congratulations - you guessed the word!"
    end
    @game.start_again
  end

  def divider
    puts "--------"
  end

end