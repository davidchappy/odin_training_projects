class Game

  attr_reader :current_turn, :word, :current_match, :turn_limit, :player
  attr_accessor :player_guesses

  def initialize(saved_game=false)
    @current_match = self
    @player = Player.new(@current_match)
    @board = Board.new(@current_match)
    @saver = Saver.new(@current_match)
    if saved_game
      @board.display_saves(@saver.saves)
      print "Type the number of the game you'd like to load: "
      id = gets.chomp
      while id.match(/ˆ[0-9]+$/) == false
        print "Please type a number: "
        id = gets.chomp
      end
      loaded_game = @saver.load(id)
      state = loaded_game[:state]
      @word = state[:word]
      @player_guesses = state[:player_guesses]
      @current_turn = state[:current_turn]
      process_turn(true)
    else
      @word ||= get_word("dictionary.txt")
      # p @word
      @player_guesses ||= {
        letters: [], 
        misses: []
      }
      if @player_guesses[:letters] == [] 
        get_blanks
      end
      @current_turn ||= 0
      process_turn
    end
  end

  def process_turn(load=false)
    puts "The word has #{@word.length} letters."
    if load
       @board.update
    else
      puts "#{$turn_limit - @current_turn} turns left."
    end
    while @current_turn <= $turn_limit
      @current_turn += 1
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
      @saver.save if @player.save?
    end
    puts "The word was '#{@word}'."
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
    words = []
    lines.each do |line|
      next if line.split("").length > $word_limit
      words << line
    end
    word = words[rand(words.length)].chomp.downcase
  end

  def get_blanks
    (@word.length).times do |index|
      @player_guesses[:letters] << "_"
    end 
  end

end