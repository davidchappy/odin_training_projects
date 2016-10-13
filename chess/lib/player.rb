# -*- encoding : utf-8 -*-
class Player

  attr_reader :color, :num, :name

  def initialize(num, color, name=false)
    @num = num
    @color = color
    @name = name || GameIO.request_player_name(num, color)
  end

  def take_turn(board, check=false)
    move = []

    GameIO.give_output("It's #{@name}'s (#{@color}) turn.\nChoose a valid piece and destination separated by a comma (ex: a2,a3): ", "print")
    move = GameIO.get_input.split(",").collect!{|x| x.strip || x }
    target = move[0]
    # p target
    # p board.positions[target.to_sym].moves(board)
    destination = move[1]
    case
    when !board.valid_tile?(target)
      GameIO.give_output("Sorry, that coordinate is not on the board.")
      take_turn(board)
    when !board.is_piece?(target)
      GameIO.give_output("Sorry, there's no piece there.")
      take_turn(board)
    when board.is_enemy?(target, self.color)
      GameIO.give_output("Sorry, you can't move your opponent's piece.")
      take_turn(board)
    when !board.positions[target.to_sym].possible_move?(destination, board)
      GameIO.give_output("Sorry, that's not a possible move for that piece.")
      take_turn(board)
    else
    end

    return move
  end

end