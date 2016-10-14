# -*- encoding : utf-8 -*-
class Board
  include ChessHelpers

  attr_accessor :board, :positions, :captured

  def initialize
    @@tiles = generate_tiles
    @positions = add_pieces_to_tiles(@@tiles)
    @board = generate_board  
    @captured = []
  end

  def self.tiles
    @@tiles
  end

  def generate_tiles      
    positions = {}
    8.downto(1).each do |number|
      fill_row(number, $blank, positions)
    end
    positions  
  end

  def add_pieces_to_tiles(positions)
    Piece.generate_pieces.each do |key, piece|
      positions[piece.position.to_sym] = piece
    end
    positions
  end

  def generate_board
    board = []

    # box drawing characters: https://en.wikipedia.org/wiki/Box-drawing_character
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
    # add rows to board and merge tiles
    8.downto(1) do |num|
      board << "#{num.to_s.colorize(:white)} " + merge_tiles_with_board("a".upto("h").to_a, num, v_line) + v_line
      unless num == 1
        board << "  #{left_join}" + spawn(spawn(h_line, 3) + cross, 7) + spawn(h_line, 3) + right_join
      end
    end
    board << bottom_border
    board
  end

  def merge_tiles_with_board(letters, number, separator)
    output = ""
    letters.each do |letter|
      position = @positions[(letter + number.to_s).to_sym]
      if position == $blank
        output += "#{ separator + ' ' + position + ' ' }" 
      else # if tile has a piece, must use piece's 
        output += "#{ separator + ' ' + position.icon + ' ' }" 
      end
    end 
    output
  end

  def update_board(move)
    start_position = move[0]
    piece = find_piece(start_position)
    destination = move[1]
    piece.position = destination
    @positions[start_position.to_sym] = $blank
    @positions[destination.to_sym] = piece
    @board = generate_board
  end

  def valid_tile?(coordinate)
    return true if !coordinate.nil? && positions.keys.include?(coordinate.to_sym)
    false
  end

  def is_piece?(coordinate)
    return true if !coordinate.nil? && positions[coordinate.to_sym].class.ancestors.include?(Piece)
    false
  end

  def open_tile?(coordinate)
    return true if valid_tile?(coordinate) && !is_piece?(coordinate)
    false
  end

  def is_enemy?(coordinate, player_color)
    return true if is_piece?(coordinate) && player_color != positions[coordinate.to_sym].color
    false
  end

  def obstructed?(coordinate, player_color)
    return true if is_piece?(coordinate) && !is_enemy?(coordinate, player_color)
    false
  end

  def find_piece(coordinate)
    raise "that's not a piece" if !is_piece?(coordinate)
    piece = positions[coordinate.to_sym]
  end

  def get_player_pieces(current_player)
    pieces = []
    @positions.keys.each do |key|
      if is_piece?(key.to_s) && @positions[key].color == current_player.color
        pieces << @positions[key]
      end
    end
    pieces
  end

  # returns array of tiles where King can move safely without being in check
  def king_safe_tiles(current_player, other_player)
    safe_tiles = []
    player_pieces = get_player_pieces(current_player)
    other_player_pieces = get_player_pieces(other_player)
    king = player_pieces.select{|p| p if p.name == "king"}[0]
    safe_tiles = king.moves(self)
    other_player_pieces.each do |piece|
      # puts "Piece: #{piece.color} #{piece.name}\nMoves: #{piece.moves(self)}\n" 
      piece.moves(self).compact.each do |move|
        safe_tiles.delete(move) if safe_tiles.include?(move)
      end
    end
    safe_tiles.compact
  end

end
