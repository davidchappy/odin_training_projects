# -*- encoding : utf-8 -*-
class Game
  include ChessHelpers

  attr_reader :board, :player1, :player2
  attr_accessor :current_player

  def self.start
    @game = Game.new
    @game.process_turns
  end

  def initialize
    @player1 = Player.new(1, "white", "David")
    @player2 = Player.new(2, "black", "Kristin")
    @current_player = set_starting_player
    @board = Board.new
    # Board.tiles.keys.each_with_index do |key,index|
    #   puts "Key: #{key}; Index: #{index}"
    # end
  end

  def process_turns
    GameIO.print_board(@board.board)
    until check_mate?
      if check?
        move = @current_player.take_turn(@board, true)
        GameIO.print_turn_update(@current_player, move, @board, true)
      else
        move = @current_player.take_turn(@board)
        GameIO.print_turn_update(@current_player, move, @board)
      end
      @board.update_board(move)
      GameIO.print_board(@board.board)
      GameIO.print_captured(@board.captured)
      @current_player = switch_players(@current_player)
    end
    GameIO.print_board(@board.board)
    start_again
  end

  def set_starting_player
    [@player1,@player2].sample
  end

  def switch_players(current_player=@current_player, players=[@player1, @player2])
    current_player == players[0] ? players[1] : players[0]
  end

  def check?
    false
  end

  def check_mate?
    false
  end

end
