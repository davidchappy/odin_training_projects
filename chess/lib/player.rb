# -*- encoding : utf-8 -*-
class Player

  attr_reader :color, :num, :name

  def initialize(num, color, name=false)
    @num = num
    @color = color
    @name = name || GameIO.request_player_name(num, color)
  end

  def take_turn(board)
    GameIO.give_output("Choose a valid piece and destination separated by a comma (ex: a8,a4): ", "print")
    move = GameIO.get_input
    move = move.split(",")
    move.collect!{|x| x.strip || x }
    case
    when !board.valid_tile?(move[0])
      GameIO.give_output("Sorry, that coordinate is not on the board.")
      take_turn(board)
    when !board.is_piece?(move[0])
      GameIO.give_output("Sorry, there's no piece there.")
      take_turn(board)
    when !board.positions[move[0].to_sym].legal_move?(move[1])
      GameIO.give_output("Sorry, that's not a legal move for that piece.")
      take_turn(board)
    else
    end
    
    # until board.valid_tile?(move[0]) && !board.is_piece?([move[0]])
    #   GameIO.give_output("Choose a piece to move and destination separated by a comma (ex: a8,a4): ", "print")
    #   move = GameIO.get_input

    # elsif !board.positions[move[0].to_sym].legal_move?(move[1])
    #   GameIO.give_output("Choose a piece to move and destination separated by a comma (ex: a8,a4): ", "print")
    # end

    #   && board.positions[move[0].to_sym].legal_move?(move[1])

    move

  end

end