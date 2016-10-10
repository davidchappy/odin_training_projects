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
    @player1 = Player.new(1, "white", "David")
    @player2 = Player.new(2, "blue", "Kristin")
    @current_player = set_starting_player
    puts @current_player.name
  end

  # def process_turns
  #   until game_over?
  #     @current_player = switch_players(@current_player)
  #     GameIO.print_board(@board.board)
  #     GameIO.print_turn_update(@current_player)
  #     move = @current_player.move
  #     @board.board = process_move(move)
  #   end
  #   GameIO.print_board(@board.board)
  #   start_again
  # end

end
