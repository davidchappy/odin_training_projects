class Game 

  attr_reader :player1, :player2
  attr_accessor :current_player

  def self.start
    set_players
    Board.start_board
    Board.print_start(@player1, @player2)
    Board.print_board
    set_starting_player
    @current_player.take_turn
  end

  def self.set_players
    @player1 = Player.create(1, "Fred")
    @player2 = Player.create(2, "Ricky")
    @@symbols = ["x", "o"]
    @player1.symbol = @@symbols.delete(@@symbols.sample)
    @player2.symbol = @@symbols.first
  end

  def self.process_turn(choice)
    if validate_choice(choice)
      Board.board[choice.to_sym] = @current_player.symbol
      Board.print_board
      check_for_game_over
      switch_players
    end
    @current_player.take_turn
  end

  def self.switch_players
    players = [@player1, @player2]
    if players[0] == @current_player
      @current_player = players[1] 
    else
      @current_player = players[0]
    end
    puts @current_player.name + "\'s turn."
  end

  def self.set_starting_player
    @current_player = [@player1, @player2].sample
    puts @current_player.name + " starts!"
  end

  def self.current_player
    @current_player
  end

  def self.validate_choice(choice)
    valid_choices = [["a", "b", "c"],[1,2,3]]
    characters = choice.split("")
    current_board = Board.board
    case 
    when Board.spot_taken?(choice)
      puts "Sorry, that spot is taken."
      return false
    when valid_choices[0].include?(characters[0]) == false || valid_choices[1].include?(characters[1].to_i) == false
      puts "Oops, that isn't a valid spot on the board."
      return false   
    else  
      return true
    end
  end

  def self.check_for_game_over
    case 
    when Board.full?
      declare_game_end("draw")
    when Board.row_victory? || Board.column_victory? || Board.diagonal_victory?
      declare_game_end
    end
  end

  def self.declare_game_end(result=nil)
    if result == "draw"
      puts "Game Over! This game ends in a draw."
    else
      puts "Game Over! #{@current_player.name} is the winner!"
    end
    Board.print_divider
    print "Play again? (Y/n): "
    choice = gets.chomp
    Board.print_divider
    if choice.downcase == "n"
      exit
    else
      Board.start_board
      Game.start
    end
  end

end

class Board

  attr_accessor :board
  attr_reader :blank_spot
  
  def self.start_board
    @blank_spot = "—"
    @board = {  a1: @blank_spot, 
                a2: @blank_spot, 
                a3: @blank_spot, 
                b1: @blank_spot, 
                b2: @blank_spot, 
                b3: @blank_spot, 
                c1: @blank_spot, 
                c2: @blank_spot, 
                c3: @blank_spot }
  end

  def self.board
    @board
  end

  def self.print_board
    print_divider
    puts "  " + "1" + " " + "2" + " " + "3"
    puts "A" + " " + board[:a1].upcase + " " + board[:a2].upcase + " " + board[:a3].upcase
    puts "B" + " " + board[:b1].upcase + " " + board[:b2].upcase + " " + board[:b3].upcase
    puts "C" + " " + board[:c1].upcase + " " + board[:c2].upcase + " " + board[:c3].upcase
    print_divider
  end

  def self.print_start(player1, player2)
    puts "Tic Tac Toe!"
    puts player1.name + "(#{player1.symbol.capitalize})" + " vs. " + player2.name + "(#{player2.symbol.capitalize})"
    puts "Choose your spot with a letter (for a row) and a number (for a column)."
  end

  def self.print_divider
    puts "----------"
    puts ""
  end

  def self.spot_taken?(choice)
    return true if board[choice.to_sym] && board[choice.to_sym] != "—"
  end

  def self.full?
    board.all? do |k,v|
      v != @blank_spot
    end
  end

  def self.row_victory?
    symbol = Game.current_player.symbol
    row1 = [@board[:a1], @board[:a2], @board[:a3]]
    row2 = [@board[:b1], @board[:b2], @board[:b3]]
    row3 = [@board[:c1], @board[:c2], @board[:c3]]
    case 
    when row1.all? {|v| v == symbol }
      return true
    when row2.all? {|v| v == symbol }
      return true
    when row3.all? {|v| v == symbol }
      return true
    else
      return false
    end
  end

  def self.column_victory?
    symbol = Game.current_player.symbol
    col1 = [@board[:a1], @board[:b1], @board[:c1]]
    col2 = [@board[:a2], @board[:b2], @board[:c2]]
    col3 = [@board[:a3], @board[:b3], @board[:c3]]
    case 
    when col1.all? {|v| v == symbol }
      return true
    when col2.all? {|v| v == symbol }
      return true
    when col3.all? {|v| v == symbol }
      return true
    else
      return false
    end
  end

  def self.diagonal_victory?
    symbol = Game.current_player.symbol
    a1_c3 = [@board[:a1], @board[:b2], @board[:c3]]
    c1_a3 = [@board[:a3], @board[:b2], @board[:c1]]
    case 
    when a1_c3.all?{ |s| s == symbol }
      return true
    when c1_a3.all?{ |s| s == symbol }
      return true
    else
      return false
    end
  end

end

class Player

  attr_reader :name
  attr_accessor :symbol

  def self.create(player_number, player_name=nil)
    if player_name == nil
      print "Player " + player_number + ": "
      player_name = gets.chomp
    end
    self.new(player_name)
  end

  def initialize(player_name)
    @name = player_name
  end

  def take_turn
    print "Choose a row (ex: A) and a column (ex: 1): "
    choice = gets.chomp.downcase.slice(0..1)
    Game.process_turn(choice)
  end

end

# Game.start