class Game

  attr_reader :game, :players, :player1, :player2
  attr_accessor :board, :current_player

  def initialize(player1, player2)
    @player1 = Player.new(player1)
    @player2 = Player.new(player2)
    @players = [@player1, @player2]
    @current_player = set_starting_player
    @board = start_board
  end

	def self.start
    @game = Game.new("David", "Kristin")
    @game
  end

  def start_board
    board = {}
    holes = []
    6.times do |i|
      ("a".."h").each do |letter|
        holes << (letter + (i+1).to_s)
      end
    end
    holes.each do |spot|
      board[spot.to_sym] = "-"
    end
    board
  end

  def set_starting_player
    players.sample
  end

end

class Player

  attr_reader :name

  def initialize(name)
    @name = name
  end

end