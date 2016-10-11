# -*- encoding : utf-8 -*-
class Player

  attr_reader :color, :num, :name

  def initialize(num, color, name=false)
    @num = num
    @color = color
    @name = name || GameIO.request_player_name(num, color)
  end

  def take_turn(board, move=["target","destination"])
    unless board.valid_tile?(move[0]) && board.is_piece?([move[0]])
      GameIO.give_output("Choose a piece to move and destination separated by a comma (ex: a8,a4): ", "print")
      move = GameIO.get_input
      move = move.split(",")
      move.collect!{|x| x.strip || x }
    else
      take_turn(board, move)
    end

    #   && board.positions[move[0].to_sym].legal_moves.include?(move[1])

    # destination = "filler"
    # until board.positions.keys.include?(destination.to_sym) && board.positions[target.to_sym].legal_moves.include?(destination)
    #   GameIO.give_output("Choose a destination by its coordinates (ex: a5): ", "print")
    #   target = GameIO.get_input
    # end
    move

  end

end