# -*- encoding : utf-8 -*-
require 'spec_helper'

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

  describe "#promotable?" do

    let(:pawn) { Piece::Pawn.new("white", "") }

    before do
      board.captured << Piece::Queen.new("white", "")
      board.captured << Piece::Rook.new("white", "")
    end

    it "returns true if a pawn can be promoted" do
      pawn.position = "c8"
      board.positions[:c8] = pawn
      expect(board.promotable?(pawn)).to eq(true)
    end

    it "returns false if pawn has not reached the final row" do
      pawn.position = "c7"
      board.positions[:c7] = pawn
      expect(board.promotable?(pawn)).to eq(false)
    end

  end

  describe "#promote" do

    let(:white_pawn) { Piece::Pawn.new("white", "") }
    let(:black_pawn) { Piece::Pawn.new("black", "") }

    before(:each) do
      allow(GameIO).to receive(:print_promotion).and_return("")
      allow(GameIO).to receive(:get_input).and_return("1")
    end

    it "replaces a promoted pawn with a captured piece" do
      board.captured << Piece::Queen.new("white", "")
      board.captured << Piece::Rook.new("white", "")
      queen = board.promote(white_pawn)
      board.positions[:c8] = queen
      expect(board.positions[:c8]).to be_a(Piece::Queen)
    end

    it "works for both colors" do
      board.captured << Piece::Queen.new("black", "")
      board.captured << Piece::Rook.new("black", "")
      queen = board.promote(black_pawn)
      board.positions[:c1] = queen
      expect(board.positions[:c1]).to be_a(Piece::Queen)
    end

  end

  describe "#en_passant?" do
    
    let(:white_pawn) { Piece::Pawn.new("white", "f5") }
    let(:black_pawn) { Piece::Pawn.new("black", "g5") }

    it "returns true if a pawn is able to perform en_passant" do
      board.positions[:f5] = white_pawn
      board.positions[:g5] = black_pawn
      expect(board.en_passant?(white_pawn)).to eq(true)
    end

  end

  describe "#process_en_passant" do

    let(:white_pawn) { Piece::Pawn.new("white", "f5") }
    let(:black_pawn) { Piece::Pawn.new("black", "g5") }

    it "moves attacking pawn diagonally and captures lateral pawn" do
      board.positions[:f5] = white_pawn
      board.positions[:g5] = black_pawn
      move = ["f5", "g6"]
      board.process_en_passant(move)
      expect(board.positions[:g5]).to eq($blank)
      expect(board.captured[0].position).to eq("")
      expect(board.captured.length).to eq(1)
    end

  end

  describe "#casteable" do

    let(:king) { Piece::King.new("white", "e1") }
    let(:player) do
      game.current_player = game.player1
    end

    it "returns false if king cannot castle" do
      expect(board.castleable(player)).to eq(false) 
    end

    it "returns array with first member true if king can castle on left side" do
      board.positions[:b1] = $blank
      board.positions[:c1] = $blank
      board.positions[:d1] = $blank
      expect(board.castleable(player)).to be_a(Array)
      expect(board.castleable(player)[0]).to eq(true)
      expect(board.castleable(player)[1]).to eq(false)
    end

    it "returns array with second member true if king can castle on right side" do
      board.positions[:f1] = $blank
      board.positions[:g1] = $blank
      expect(board.castleable(player)).to be_a(Array)
      expect(board.castleable(player)[0]).to eq(false)
      expect(board.castleable(player)[1]).to eq(true)
    end

    context "when a king or rook has moved" do

      it "returns false" do
        rook = Piece::Rook.new("white", "a1")
        rook.has_moved = true
        board.positions[:a1] = rook
        board.positions[:b1] = $blank
        board.positions[:c1] = $blank
        board.positions[:d1] = $blank
        expect(board.castleable(player)).to_not be_a(Array)
        expect(board.castleable(player)).to eq(false)
      end
    end

  end

  describe "#castle" do

    let(:player) do
      game.current_player = game.player1
    end
    let(:castle) { board.castle(player, [true, false]) }

    it "moves the king but returns move coordinates for the rook" do
      board.positions[:b1] = $blank
      board.positions[:c1] = $blank
      board.positions[:d1] = $blank
      castle
      expect(board.positions[:c1]).to be_a(Piece::King)
      expect(castle).to eq(["a1","d1"])
    end

    it "castles king in chosen direction if both sides are available" do
      board.positions[:b1] = $blank
      board.positions[:c1] = $blank
      board.positions[:d1] = $blank
      board.positions[:f1] = $blank
      board.positions[:g1] = $blank
      expect(board.castleable(player)[0]).to eq(true)
      expect(board.castleable(player)[1]).to eq(true)
      expect(board.castle(player, "l")).to eq(["a1","d1"])
      expect(board.castle(player, "r")).to eq(["h1","f1"])
    end

    it "marks the king and rook as having moved" do
      move = castle
      board.update_board(move)
      expect(board.positions[:c1].has_moved).to eq(true)
      expect(board.positions[:c1]).to be_a(Piece::King)
      expect(board.positions[:d1].has_moved).to eq(true)
      expect(board.positions[:d1]).to be_a(Piece::Rook)
    end

  end

end
