class Game

  attr_reader :game, :players, :player1, :player2
  attr_accessor :board, :current_player

  def initialize(player1, player2)
    @player1 = Player.new(player1)
    @player2 = Player.new(player2)
    @players = [@player1, @player2]
    set_colors(["R", "B"])
    @current_player = set_starting_player
    @board = start_board
  end

	def self.start
    @game = Game.new("David", "Kristin")
    # @game.process_turns
    @game
  end

  def process_turns
    until game_over?
      puts print_board
      @board = process_choice(@current_player.choose)
      if game_over?
        print_game_end 
      else
        switch_players
      end
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
    return current_player == players[0] ? players[1] : players[0]
  end

  def add_token_to_board(choice, board=@board)
    column = []
    board.each { |spot,value| column << spot if spot.to_s[0] == choice.to_s[0] }
    column.reverse!
    column.each do |spot|
      board
    end
    p board
    board
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

  def print_board
    output = ""
    output += "   a b c d e f g\n"
    rows = {}
    @board.each do |location,value|
      rows[location[1]] ||= [(location[1] + " ")] 
      rows[location[1]] << value
    end
    rows.each do |row_num,row|
      output << row.join(" ") << "\n"
    end
    output
  end

end

class Player

  attr_reader :name
  attr_accessor :color

  def initialize(name)
    @name = name
    @color = nil
  end

  def choose
    $stdin.to_sym
  end

end

# Settings
# $stdin = STDIN
$blank_spot = "-"

Game.start