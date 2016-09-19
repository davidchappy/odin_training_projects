class Game

  attr_reader :current_turn, :turns_remaining, :word, :current_match, :turn_limit
  attr_accessor :player_guesses

  def self.start(saved_game=false)
    # if load
      # if exists, load file using saves object, else throw error and start new game
      # update saved_game   
    # end
    Game.new(saved_game)
  end

  def initialize(saved_game=false)
    unless saved_game
      @current_match = self
      @player ||= Player.new(@current_match)
      @word ||= get_word("dictionary.txt")
      p @word
      @player_guesses ||= {
        letters: [], 
        misses: []
      }
      if @player_guesses[:letters] == [] 
        get_blanks
      end
      @board ||= Board.new(@current_match)
      @current_turn ||= 1
    else
      # load variables from saved state
    end

    process_turn
  end

  def process_turn
    while @current_turn <= $turn_limit
      guess_array = @player.guess
      guess = guess_array[0]
      guess_type = guess_array[1]
      if guess_type == "w"
        process_word(guess)
      else
        process_letter(guess)
      end
      if @player_guesses[:letters].join("") == @word
        @board.match_result(true)
      end
      @board.update
      @current_turn += 1
    end
    @board.match_result
    start_again
  end

  def process_letter(letter)
    if @word.split("").include?(letter)
      puts "Good job!"
      @word.split("").each_with_index do |l,index|
        if l == letter
          @player_guesses[:letters][index] = letter
        end
      end 
    else
      @player_guesses[:misses] << letter
      puts "Sorry, that letter's not in the word." 
    end
  end

  def process_word(word)
    if @word == word
      @board.match_result(true)
    else
      bracketed_word = "(" + word + ")"
      @player_guesses[:misses] << bracketed_word
      puts "Sorry, that's not the right word." 
    end
  end

  def start_again
    @board.divider
    print "Play again? (Y/n) "
    choice = gets.chomp
    @board.divider
    if choice.downcase == "n"
      exit
    else
      Game.start
    end
  end

  def get_word(file)
    lines = File.readlines(file)
    word = lines[rand(lines.length)].chomp
  end

  def get_blanks
    (@word.length).times do |index|
      @player_guesses[:letters] << "_"
    end 
  end

end