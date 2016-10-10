# -*- encoding : utf-8 -*-
class Game

  def self.start
    @game = Game.new
    @board = Board.new
    puts @board.board
  end

end
