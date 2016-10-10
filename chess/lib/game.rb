# -*- encoding : utf-8 -*-
class Game
  include ChessHelpers

  attr_reader :board, :player1, :player2
  attr_accessor :current_player

  def self.start
    @game = Game.new
    @board = Board.new
    puts @board.board
  end

  def initialize
    @player1 = Player.new(1, "white")
    @player2 = Player.new(2, "blue")
    @current_player = set_starting_player

    puts @current_player.name
  end

end
