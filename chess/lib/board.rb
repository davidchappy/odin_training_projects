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

  def inspect
    output = ""
    @positions.each do |position, value|
      if is_piece?(position.to_s)
        if value.respond_to?(:has_moved)
          moved = "Moved: " + value.has_moved.to_s
        end
        output += "#{value.position}: #{value.color} #{value.name} #{moved}\n"
      else
        # next
        output += position.to_s + ": blank" + "\n" 
      end
    end
    puts output
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
    # update piece's position variable to match new location
    start_position = move[0]
    piece = find_piece(start_position)
    piece.has_moved = true if piece.is_a?(Piece::King) || piece.is_a?(Piece::Rook)
    destination = move[1]
    piece.position = destination
    @positions[start_position.to_sym] = $blank
    @positions[destination.to_sym] = piece
    if promotable?(piece)
      piece = promote(piece) 
      piece.position = destination
      @positions[destination.to_sym] = piece
    end
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

  def promotable?(piece)
    if  (piece.class == Piece::Pawn) && 
        (@captured.length > 0) &&
        (@captured.select{|p| p if p.color == piece.color}.length > 0)
        if piece.color == "white" 
          return true if piece.position[-1] == "8"
        else
          return true if piece.position[-1] == "1"
        end
    end
    false
  end

  def promote(piece)
    current_player_captures = @captured.select{|p| p if p.color == piece.color}
    GameIO.print_promotion(current_player_captures)
    input = GameIO.get_input.to_i - 1
    promoted_piece = current_player_captures[input]
    promoted_piece
  end

  def en_passant?(pawn)
    if pawn.class == Piece::Pawn
      col_as_num = pawn.position[0].ord
      row = pawn.position[1]
      right_position = "#{(col_as_num+1).chr}#{row}"
      left_position = "#{(col_as_num-1).chr}#{row}"
      if pawn.color == "white" && row == "5"
        return true if !@positions[right_position.to_sym].nil? && is_enemy?(right_position, pawn.color) 
        return true if !@positions[left_position.to_sym].nil? && is_enemy?(left_position, pawn.color) 
      elsif pawn.color == "black" && row == "4"
        return true if !@positions[right_position.to_sym].nil? && is_enemy?(right_position, pawn.color) 
        return true if !@positions[left_position.to_sym].nil? && is_enemy?(left_position, pawn.color) 
      end
    end
    false
  end

  # checks if move is en passant; clears spot where enemy was, adds enemy to captured
  def process_en_passant(move)
    destination = move[1]
    piece = @positions[move[0].to_sym]
    col_as_num = piece.position[0].ord
    row = piece.position[1]
    right = "#{(col_as_num+1).chr}#{row}"
    left = "#{(col_as_num-1).chr}#{row}"
    if piece.color == "white"
      upper_left = "#{(col_as_num-1).chr}#{(row.to_i + 1).to_s}"
      upper_right = "#{(col_as_num+1).chr}#{(row.to_i + 1).to_s}"
      if destination == upper_left 
        @captured << @positions[left.to_sym]
        @positions[left.to_sym].position = ""
        @positions[left.to_sym] = $blank
      elsif destination == upper_right
        @captured << @positions[right.to_sym]
        @positions[right.to_sym].position = ""
        @positions[right.to_sym] = $blank
      end
      return true
    else 
      lower_left = "#{(col_as_num-1).chr}#{(row.to_i - 1).to_s}"
      lower_right = "#{(col_as_num+1).chr}#{(row.to_i - 1).to_s}"
      if destination == lower_left 
        @captured << @positions[left.to_sym]
        @positions[left.to_sym].position = ""
        @positions[left.to_sym] = $blank
      elsif destination == lower_right
        @captured << @positions[right.to_sym]
        @positions[right.to_sym].position = ""
        @positions[right.to_sym] = $blank
      end
      return true
    end
    false
  end

  # figures out if player can castle their king, returning false or array of true/false for l/r
  def castleable(player)
    castleable = []
    pieces = get_player_pieces(player)
    king = pieces.select{ |p| p if p.name == "king" }[0]
    rooks = pieces.select{ |p| p if p.name == "rook" }
    left_rook = rooks.select{ |r| r if r.position == "a8" || r.position == "a1" }[0]
    right_rook = rooks.select{ |r| r if r.position == "h8" || r.position == "h1" }[0]
    rooks.each { |rook| rooks.delete(rook) if rook.has_moved }

    if player.color == "white"
      left_side = @positions.keys.select{ |t| @positions[t] if t == :d1 || t == :c1 || t == :b1 }
      right_side = @positions.keys.select{ |t| @positions[t] if t == :f1 || t == :g1 }     
    else 
      left_side = @positions.keys.select{ |t| @positions[t] if t == :d8 || t == :c8 || t == :b8 }
      right_side = @positions.keys.select{ |t| @positions[t] if t == :f8 || t == :g8 }  
    end

    case
    when king.has_moved || rooks.length == 0
      return false
    when left_side.any?{ |t| @positions[t] != $blank } && right_side.any?{ |t| @positions[t] != $blank }
      return false
    when rooks.length == 1
      if left_side.all?{ |t| @positions[t] == $blank } && left_rook.has_moved == false
        puts "got to left side and rook has moved false"
        castleable[0] = true
        castleable[1] = false 
      end
      if right_side.all?{ |t| @positions[t] == $blank } && right_rook.has_moved == false
        puts "got to right side"
        castleable[0] ||= false 
        castleable[1] = true 
      end
    when rooks.length == 2
      castleable[0] = left_side.all?{ |t| @positions[t] == $blank } ? true : false
      castleable[1] = right_side.all?{ |t| @positions[t] == $blank } ? true : false
    else
      return false
    end

    if castleable == [] || castleable.nil?
      return false
    else
      return castleable
    end
  end

  def castle(player, input)
    move = []
    castle_left = (input.is_a?(Array) && input[0] == true) || input == "l" ? true : false
    castle_right = (input.is_a?(Array) && input[1] == true) || input == "r" ? true : false
    # p castle_left
    # p castle_right
    pieces = get_player_pieces(player)

    # determine player color, move king and prep returned move with rook coordinates
    case 
    when player.color == "white"
      king = find_piece("e1")
      if castle_left
        move[0] = "a1"
        move[1] = "d1" 
        king.position = "c1"
        king.has_moved = true
        @positions[:c1] = king
      elsif castle_right
        move[0] = "h1"
        move[1] = "f1" 
        king.position = "g1"
        king.has_moved = true
        @positions[:g1] = king
      end
    when player.color == "black" 
      king = find_piece("e8")
      if castle_left
        move[0] = "a8"
        move[1] = "d8" 
        king.position = "c8"
        king.has_moved = true
        @positions[:c8] = king
      elsif castle_right
        move[0] = "h8"
        move[1] = "f8" 
        king.position = "g8"
        king.has_moved = true
        @positions[:g8] = king
      end
    end
    move
  end

end


