# -*- encoding : utf-8 -*-
class Board
  include ChessHelpers

  attr_accessor :board, :positions

  def initialize
    @positions ||= generate_positions
    @positions[:b4] = icon_white("\u2654")
    @positions[:g4] = icon_white("\u2654")
    @positions[:a7] = icon_black("\u265A")
    @board = generate_board
  end

  def generate_board
    board = []

    up_left = icon_white("\u250c")
    up_right = icon_white("\u2510")
    down_left = icon_white("\u2514")
    down_right = icon_white("\u2518")
    top_join = icon_white("\u252c")
    bot_join = icon_white("\u2534")
    left_join = icon_white("\u251c")
    right_join = icon_white("\u2524")
    h_line = icon_white("\u2500")
    v_line = icon_white("\u2502")
    cross = icon_white("\u253c")

    header_row = "    a   b   c   d   e   f   g   h".colorize(:white)
    top_border = "  " + up_left + spawn(spawn(h_line, 3) + top_join, 7) + spawn(h_line, 3) + up_right
    bottom_border = "  " + down_left + spawn(spawn(h_line, 3) + bot_join, 7) + spawn(h_line, 3) + down_right

    board << header_row
    board << top_border
    8.downto(1) do |num|
      board << "#{num.to_s.colorize(:white)} " + print_positions("a".upto("h").to_a.reverse, num, v_line) + v_line
      unless num == 1
        board << "  #{left_join}" + spawn(spawn(h_line, 3) + cross, 7) + spawn(h_line, 3) + right_join
      end
    end
    board << bottom_border

    board
  end

  def generate_positions      
    positions = {}
    8.downto(1).each do |number|
      ("a".."h").each do |letter|
        positions[(letter + number.to_s).to_sym] = $blank 
      end
    end
    positions
  end

  def print_positions(letters, number, separator)
    output = ""
    letters.each do |letter|
      output += "#{ separator + ' ' + @positions[(letter + number.to_s).to_sym] + ' ' }" 
    end 
    output
  end

end
