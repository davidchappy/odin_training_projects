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
    GameIO.print_board(@board.board)
  end

  def process_turns
    loop do
      # p @board
      if check?
        GameIO.print_check(@current_player, @board.king_safe_tiles(@current_player, switch_players))
        move = @current_player.take_turn(@board, true, @board.king_safe_tiles(@current_player, switch_players))
      else
        move = @current_player.take_turn(@board)
      end
      GameIO.print_turn_update(@current_player, move, @board)
      @board.update_board(move)
      if check_mate?
        GameIO.print_finish(switch_players)
        start_again
      end
      GameIO.print_board(@board.board)
      GameIO.print_captured(@board.captured)
      @current_player = switch_players(@current_player)
    end
  end

  def set_starting_player
    [@player1,@player2].sample
  end

  def switch_players(current_player=@current_player, players=[@player1, @player2])
    current_player == players[0] ? players[1] : players[0]
  end

  def check?
    return true if king_attackers.length > 0
    false
  end

  # return array of pieces placing the king in check
  def king_attackers
    attackers = []    
    king = @board.get_player_pieces(@current_player).select{|p| p if p.name == "king"}[0]
    other_player_pieces = @board.get_player_pieces(switch_players)
    other_player_pieces.each do |piece|
      piece.moves(@board).compact.each do |move|
        if @board.is_piece?(move) && @board.positions[move.to_sym] == king
          attackers << @board.positions[piece.position.to_sym]
        end
      end
    end
    attackers
  end

  def check_mate?
    king = @board.get_player_pieces(@current_player).select{|p| p if p.name == "king"}[0]
    legal_moves = king.moves(@board).compact
    safe_moves = @board.king_safe_tiles(@current_player, switch_players).compact
    
    if  king_attackers.length > 0 &&
        safe_moves.length == 0 && 
        legal_moves.length > 0 
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
