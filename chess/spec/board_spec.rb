# -*- encoding : utf-8 -*-
require './chess.rb'

describe Board do

  let(:board) { Board.new }
  let(:game) { Game.new }

  describe "#generate_tiles" do

    let(:positions) { board.generate_tiles }

    it "returns a hash with 64 keys" do
      expect(positions).to be_a(Hash)
      expect(positions.length).to eq(64)
    end

    it "returns blank spots" do
      expect(positions.values.all? {|spot| spot == $blank } ).to eq(true)
    end

  end

  describe "#add_pieces_to_tiles" do

    let(:pieces) { Piece.generate_pieces }
    let(:positions) { board.positions }

    it "fills the board with correct pieces" do
      keys = positions.keys
      keys.each_with_index do |key, index|
        if (8..15).include?(index) || (48..55).include?(index)
          expect(positions[key]).to be_a(Piece::Pawn)
        end
      end

      expect(positions[:a1]).to be_a(Piece::Rook)
      expect(positions[:b1]).to be_a(Piece::Knight)
      expect(positions[:c1]).to be_a(Piece::Bishop)
      expect(positions[:d1]).to be_a(Piece::Queen)
      expect(positions[:e1]).to be_a(Piece::King)
      expect(positions[:f1]).to be_a(Piece::Bishop)
      expect(positions[:g1]).to be_a(Piece::Knight)
      expect(positions[:h1]).to be_a(Piece::Rook)

      expect(positions[:a8]).to be_a(Piece::Rook)
      expect(positions[:b8]).to be_a(Piece::Knight)
      expect(positions[:c8]).to be_a(Piece::Bishop)
      expect(positions[:d8]).to be_a(Piece::Queen)
      expect(positions[:e8]).to be_a(Piece::King)
      expect(positions[:f8]).to be_a(Piece::Bishop)
      expect(positions[:g8]).to be_a(Piece::Knight)
      expect(positions[:h8]).to be_a(Piece::Rook)

      # verify a couple blank spots
      expect(positions[:a4]).to eq($blank)
      expect(positions[:f6]).to eq($blank)
    end

    it "ensures pieces are the correct color" do
      black_keys = positions.keys[0..15]
      white_keys = positions.keys[48..63]
      black_keys.each { |key| expect(positions[key].color).to eq("black") }
      white_keys.each { |key| expect(positions[key].color).to eq("white") }
    end

    it "returns a returns a hash with 64 keys" do
      expect(positions).to be_a(Hash)
      expect(positions.length).to eq(64)
    end

  end

  describe "#generate_board" do

    let(:board_tiles) { board.generate_board }

    it "returns an array of board output characters" do
      expect(board_tiles).to be_a(Array)
      # header row (1) + top/bottom borders(2) + rows (8) + row dividers (7) = 18
      expect(board_tiles.length).to eq(18)
    end

    it "returns the header row" do
      expect(board_tiles[0]).to include("a   b   c   d   e   f   g   h")
    end

    # not feasible to test actual board output because of extra characters added by colorize plugin
    # unnecessary to test the #merge_tiles_with_board helper method

  end

  describe "#valid_tile?" do

    it "returns true if input is a valid tile on the board" do
      expect(board.valid_tile?("a8")).to be(true)
      expect(board.valid_tile?("d8")).to be(true)
    end

    it "returns false if input is not a valid tile" do
      expect(board.valid_tile?("b9")).to be(false)
    end
  end

  describe "#is_piece?" do

    it "returns true if input is a valid tile on the board" do
      expect(board.is_piece?("a8")).to be(true)
    end

    it "returns false if input is not a valid tile" do
      expect(board.is_piece?("a4")).to be(false)
    end
  end

  describe "#open_tile?" do

    it "returns true if coordinate is on the board and blank" do
      board.positions[:e6] = $blank
      board.positions[:d8] = Piece::Queen.new("black", "d8")
      expect(board.open_tile?("e6")).to be(true)
      expect(board.open_tile?("d8")).to be(false)
    end
  end

  describe "#get_player_pieces" do

    it "returns an array of given player's pieces" do
      expect(board.get_player_pieces(game.current_player)).to be_a(Array)
      expect(board.get_player_pieces(game.current_player)).to include(Piece::Pawn)
      expect(board.get_player_pieces(game.current_player)).to include(Piece::Queen)
    end

  end

  describe "#king_safe_tiles" do

    let(:safe_tiles) { board.king_safe_tiles(game.current_player, game.switch_players(game.current_player)) }

    it "returns array of safe tiles for current_player's king" do
      game.current_player = game.player1
      board.positions[:d2] = $blank
      board.positions[:e2] = $blank
      board.positions[:e1] = Piece::King.new("white", "e1")
      board.positions[:c3] = Piece::Queen.new("black", "c3")
      expect(safe_tiles).to include("e2")
      expect(safe_tiles.length).to eq(1)
    end

  end

end
