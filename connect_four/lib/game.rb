class Game

  attr_reader :game, :players, :player1, :player2
  attr_accessor :board, :current_player

  def self.start
    puts String.colors
    player1 = "David"
    player2 = "Kristin"
    @game = Game.new(player1, player2)
    GameIO.give_output(@game.print_welcome)
    @game.process_turns
  end

  def initialize(player1, player2)
    @player1 = Player.new(player1)
    @player2 = Player.new(player2)
    @players = [@player1, @player2]
    circle = "\u25C9".encode('utf-8')
    set_colors([circle.colorize(:red), circle.colorize(:blue)])
    @current_player = set_starting_player
    @board = start_board
  end

  def process_turns
    until game_over?
      @current_player = switch_players(@current_player)
      GameIO.give_output(print_board) 
      GameIO.give_output(print_turn_update)
      @board = add_token_to_board(@current_player.choose)
    end
    start_again
  end

  def game_over?
    if victory?
      GameIO.give_output(print_game_end("victory", current_player))
      return true
    elsif board_full?
      GameIO.give_output(print_game_end("draw")) 
      return true
    else
      return false
    end
  end

  def victory?
    return true if row_victory? || column_victory? || diagonal_victory?
    false
  end

  def row_victory?
    rows = @board.values.each_slice(7).to_a
    count_consecutive_tokens(rows)
  end

  def column_victory?
    columns = []
    (0..6).each do |i|
      columns[i] ||= []
      @board.values.each_slice(7) { |a| columns[i] << a[i] }
    end
    count_consecutive_tokens(columns)
  end

  def diagonal_victory?
   # top left to bottom right diagonal victory
    tl_diagonal_strips = []
    tl_start_points = [0,1,2,3,7,14] # these are index values of @board.keys at which a 4+ diagonal can be formed
    keys = @board.keys
    i = 0
    tl_start_points.each do |start_index|
      tl_diagonal_strips[i] ||= []
      offset = start_index
      until offset >= @board.length
        tl_diagonal_strips[i] << @board[keys[offset]]
        offset += 8
      end
      i += 1
    end
    # get rid of unintended wrapping
    tl_diagonal_strips[3].pop 

    return true if count_consecutive_tokens(tl_diagonal_strips)

    # top right to bottom left diagonal victory
    tr_diagonal_strips = []
    tr_start_points = [3,4,5,6,13,20] # these are index values of @board.keys at which a 4+ diagonal can be formed
    keys = @board.keys
    i = 0
    tr_start_points.each do |start_index|
      tr_diagonal_strips[i] ||= []
      offset = start_index
      until offset >= @board.length
        tr_diagonal_strips[i] << @board[keys[offset]]
        offset += 6
      end
      i += 1
    end
    # get rid of unintended wrapping
    tr_diagonal_strips[0].pop(3)
    tr_diagonal_strips[1].pop(2)
    tr_diagonal_strips[2].pop(1)

    return true if count_consecutive_tokens(tr_diagonal_strips)
    false
  end

  def count_consecutive_tokens(target_array)
    target_array.each do |row|
      i = 0
      row.each_with_index do |spot,index|
        i += 1 if spot == row[index - 1] && spot != $blank_spot
        return true if i >= 3
      end
    end
    false
  end

  def board_full?
    if @board.keys.any? { |spot| @board[spot] == $blank_spot }
      return false
    else
      return true
    end     
  end

  def start_again
    GameIO.give_output("Play again? (y/N) ")
    play_again = GameIO.get_input.downcase 
    if play_again == "y"
      Game.start 
    else
      exit
    end
  end

  def set_colors(colors=["R", "B"])
    @player1.color = colors.delete_at(rand(colors.length))
    @player2.color = colors[0]
  end

  def set_starting_player
    players.sample
  end

  def switch_players(current_player=@current_player, players=@players)
    current_player == players[0] ? players[1] : players[0]
  end

  def add_token_to_board(choice, player=@current_player, board=@board)
    # isolate column from choice
    column = []
    board.each { |spot,value| column << spot if spot.to_s[0] == choice }
    column.reverse!

    # add the choice to the first blank spot and return the board
    column.each do |spot|
      if board[spot] == $blank_spot
        board[spot] = player.color
        return board 
      end
    end
  end

  def start_board
    board = {}
    holes = []
    6.times do |i|
      ("a".."g").each do |letter|
        holes << (letter + (i+1).to_s)
      end
    end
    holes.each do |spot|
      board[spot.to_sym] = $blank_spot
    end
    board
  end

  def print_welcome
    output = ""
    output += "Welcome to Connect Four!\n"
    output += "First to get four consecutive tokens in a row, column or diagonally wins!\n"
    output += "#{player1.name}'s color: #{player1.color}\n"
    output += "#{player2.name}'s color: #{player2.color}\n"
    output
  end

  def print_board
    output = ""
    output += "   a b c d e f g\n".colorize(:light_white)
    rows = {}
    @board.each do |location,value|
      rows[location[1]] ||= [(location[1] + " ").colorize(:light_white)] 
      rows[location[1]] << value
    end
    rows.each do |row_num,row|
      output << row.join(" ") << "\n"
    end
    output
  end

  def print_turn_update
    "It's #{current_player.name}'s turn."
  end

  def print_game_end(result, player=@current_player)
    case result 
    when "victory"
      return "Congratulations! #{player.name} wins!"
    when "draw"
      return "The board is full - it's a tie!"
    else 
     return "Oops - game ended prematurely."
    end
  end

end