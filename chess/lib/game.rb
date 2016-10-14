# -*- encoding : utf-8 -*-
class Game
  include ChessHelpers

  attr_reader :player1, :player2
  attr_accessor :current_player, :board

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
        GameIO.print_check(@current_player, @board.king_safe_tiles(@current_player, switch_players))
        move = @current_player.take_turn(@board, true, @board.king_safe_tiles(@current_player, switch_players))
      else
        move = @current_player.take_turn(@board)
      end
      @board.update_board(move)
      GameIO.print_board(@board.board)
      GameIO.print_turn_update(@current_player, move, @board)
      GameIO.print_captured(@board.captured)
      @current_player = switch_players(@current_player)
    end
    GameIO.print_finish(switch_players)
    start_again
  end

  def set_starting_player
    [@player1,@player2].sample
  end

  def switch_players(current_player=@current_player, players=[@player1, @player2])
    current_player == players[0] ? players[1] : players[0]
  end

  def check?
    king = @board.get_player_pieces(@current_player).select{|p| p if p.name == "king"}[0]
    other_player_pieces = @board.get_player_pieces(switch_players)
    other_player_pieces.each do |piece|
      piece.moves(@board).compact.each do |move|
        if @board.is_piece?(move) && @board.positions[move.to_sym] == king
          return true
        end
      end
    end
    false
  end

  def check_mate?
    king = @board.get_player_pieces(@current_player).select{|p| p if p.name == "king"}[0]
    legal_moves = king.moves(@board).compact
    safe_moves = @board.king_safe_tiles(@current_player, switch_players).compact
    if legal_moves.length > 0 && safe_moves.length == 0
      return true
    end
    false
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

end
