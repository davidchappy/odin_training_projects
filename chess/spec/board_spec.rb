# -*- encoding : utf-8 -*-
require './chess.rb'

describe Board do

  let(:board) { Board.new }

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

    # unable to test actual output because of extra characters added by colorize plugin
    # chose not to test the #merge_tiles_with_board helper method

  end


end
