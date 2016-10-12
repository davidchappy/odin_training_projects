# -*- encoding : utf-8 -*-
class Piece
  extend ChessHelpers

  attr_reader :color, :icon
  attr_accessor :captured, :position

  def self.generate_pieces
    pieces = {}
    pieces[:w_rk1] = Rook.new("white", "a1") 
    pieces[:w_kn1] = Knight.new("white", "b1") 
    pieces[:w_bp1] = Bishop.new("white", "c1") 
    pieces[:w_kg] = King.new("white", "e1") 
    pieces[:w_qn] = Queen.new("white", "d1") 
    pieces[:w_bp2] = Bishop.new("white", "f1") 
    pieces[:w_kn2] = Knight.new("white", "g1") 
    pieces[:w_rk2] = Rook.new("white", "h1")
    pawns = fill_pawns(2, "white")
    pawns.each_with_index do |position, index|
      pieces[("w_pn" + (index+1).to_s).to_sym] = pawns[index]
    end

    pieces[:b_rk1] = Rook.new("black", "a8") 
    pieces[:b_kn1] = Knight.new("black", "b8") 
    pieces[:b_bp1] = Bishop.new("black", "c8") 
    pieces[:b_kg] = King.new("black", "e8") 
    pieces[:b_qn] = Queen.new("black", "d8") 
    pieces[:b_bp2] = Bishop.new("black", "f8") 
    pieces[:b_kn2] = Knight.new("black", "g8") 
    pieces[:b_rk2] = Rook.new("black", "h8")
    pawns = fill_pawns(7, "black")
    pawns.each_with_index do |position, index|
      pieces[("b_pn" + (index+1).to_s).to_sym] = pawns[index]
    end

    @pieces = pieces
  end

  def self.pieces
    @pieces
  end

  def initialize(color, position="")
    @color = color
    @captured = false
    @position = position
    @icon = " "
  end

  def possible_move?(destination, board)
    return true if moves(board).include?(destination)
    false
  end

  def generate_adjacent_tiles(offsets)
    adjacent_tiles = []
    # get current position's index within array of tiles keys
    all_coordinates = Board.tiles.keys
    current_position_index = all_coordinates.index(@position.to_sym)

    offsets.each do |offset|
      adjusted_index = current_position_index + offset
      tile = all_coordinates[adjusted_index].to_s if adjusted_index.between?(0,63)
      adjacent_tiles << tile
    end

    adjacent_tiles
  end

  class Pawn < Piece

    def initialize(color, position="")
      super
      @name = "pawn"
      @icon = get_icon(@color, @name)
    end

    def moves(board)
      ["a4"]
    end

  end

  class Rook < Piece

    def initialize(color, position="")
      super
      @name = "rook"
      @icon = get_icon(@color, @name)
      # temporary, for tests
    end

    def moves(board)
      offsets = [-8,-1,1,8]
      ["a4"]
    end

  end

  class Knight < Piece

    def initialize(color, position="")
      super
      @name = "knight"
      @icon = get_icon(@color, @name)
    end

    def moves(board)
      possible_moves = []
      offsets = [-17,-15,-10,-6,6,10,15,17]
      legal_moves = generate_adjacent_tiles(offsets)
      legal_moves.each do |move|
        possible_moves << move unless board.obstructed?(move, @color)
      end
      possible_moves
    end

  end

  class Bishop < Piece

    def initialize(color, position="")
      super
      @name = "bishop"
      @icon = get_icon(@color, @name)
    end

    def moves(board)
      offsets = [-9,-7,7,9]
    end

  end

  class Queen < Piece

    def initialize(color, position="")
      super
      @name = "queen"
      @icon = get_icon(@color, @name)
    end

    def moves(board)
      offsets = [-9,-8,-7,-1,1,7,8,9]
    end

  end

  class King < Piece

    def initialize(color, position="")
      super
      @name = "king"
      @icon = get_icon(@color, @name)
    end

    def moves(board)
      possible_moves = []
      offsets = [-9,-8,-7,-1,1,7,8,9]
      legal_moves = generate_adjacent_tiles(offsets)
      legal_moves.each do |move|
        possible_moves << move unless board.obstructed?(move, @color)
      end
      possible_moves
    end

  end

  def get_icon(color, piece)
    icons = {}
    icons[:white] = {
      :pawn => "\u2659".colorize(:white),
      :knight => "\u2658".colorize(:white),
      :bishop => "\u2657".colorize(:white),
      :rook => "\u2656".colorize(:white),
      :queen => "\u2655".colorize(:white),
      :king => "\u2654".colorize(:white)
    }
    icons[:black] = {
      :pawn => "\u265F".colorize(:blue),
      :knight => "\u265E".colorize(:blue),
      :bishop => "\u265D".colorize(:blue),
      :rook => "\u265C".colorize(:blue),
      :queen => "\u265B".colorize(:blue),
      :king => "\u265A".colorize(:blue)
    }

    icon = icons[color.to_sym][piece.to_sym]
  end

  def self.fill_pawns(row_num, color)
    pawns = []
    letters = ("a".."h").to_a
    letters.each_with_index do |letter,index|
      pawn = Pawn.new(color)
      pawn.position = "#{letter}#{row_num}"
      pawns[index] = pawn
    end
    pawns
  end

end