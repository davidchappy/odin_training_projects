# -*- encoding : utf-8 -*-
class Player

  attr_reader :color, :num, :name

  def initialize(num, color, name=false)
    @num = num
    @color = color
    @name = name || GameIO.request_player_name(num, color)
  end

  def take_turn(board, check=false, king_safe_tiles=nil)
    move = []

    # get valid move input from player or repeat take_turn
    GameIO.give_output("It's #{@name}'s (#{@color}) turn.\nChoose a valid piece and destination separated by a comma (ex: a2,a3): ", "print")
    input = GameIO.get_input
    if input =~ /^[a-h][1-8],\s*[a-h][1-8]$/
      move = input.split(",").collect!{|x| x.strip || x }
    else 
      GameIO.give_output("Please type 2 letter/number coordinates separated by a comma (ex: d3,e4).")
      return take_turn(board)
    end

    # validate move
    target = move[0]
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
      # update piece's position variable to match new location
      piece = board.positions[target.to_sym]
      piece.position = destination
      # if enemy is targetted, add to board.captured variable
      if board.is_enemy?(destination, self.color)
        board.captured << board.positions[destination.to_sym]
      end
      return move
    end
  end

end