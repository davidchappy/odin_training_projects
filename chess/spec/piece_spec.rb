require 'spec_helper'

describe Piece do

  let(:board) { Board.new }

  describe ".generate_pieces" do

    let(:pieces) { Piece.generate_pieces }

    it "returns a hash with 32 keys" do
      expect(pieces.length).to eq(32)
    end

    it "stores pieces by color and name" do
      expect(pieces.keys).to include(:w_rk1)
      expect(pieces.keys).to include(:b_bp1)
    end

    # this method's return value is well tested via Board#add_pieces_to_tiles

  end

  context "when initialized" do

    let(:pieces) { Piece.generate_pieces }

    it "has a color" do
      expect(pieces[:w_rk1].color).to eq("white")
      expect(pieces[:b_bp1].color).to eq("black")
    end

    it "has a position" do
      expect(pieces[:b_bp1].position).to_not be_nil
    end

    it "has an icon" do
      expect(pieces[:w_rk1].icon).to_not be_nil
    end

  end

  # won't bother testing #get_icon because of the colorize plugin's encoding
  
  describe ".fill_pawns" do

    let(:pawns) { Piece.fill_pawns(2,"white") }

    it "returns an array with 8 members" do
      expect(pawns).to be_a(Array)
      expect(pawns.length).to eq(8)
    end

    it "returns all Pawn objects" do
      expect(pawns.all?{|pawn| true if pawn.instance_of?(Piece::Pawn)}).to be(true)
    end

  end

  describe "#possible_move?" do

    let(:king) { Piece::King.new("white","e1") }

    it "returns true if piece's move method includes destination" do
      board.positions[:e2] = $blank
      expect(king.possible_move?("e2", board)).to eq(true)
      expect(king.moves(board)).to include("e2")
    end

    it "returns false if piece's move method doesn't include destination" do
      expect(king.possible_move?("d1", board)).to eq(false)
      expect(king.moves(board)).not_to include("d1")
    end

  end

  describe "#generate_paths_for" do

    let(:queen) { Piece::Queen.new("white","d4") }

    it "returns open path (as array) for each adjacent tile" do
      offsets = [-9,-8,-7,-1,1,7,8,9]
      expect(queen.generate_paths_for(offsets, board)).to include("f6")
      expect(queen.generate_paths_for(offsets, board)).to include("c3")
      expect(queen.generate_paths_for(offsets, board)).not_to include("b5")
      expect(queen.generate_paths_for(offsets, board)).not_to include("f3")
    end

  end

  describe Piece::King do

    let(:king) { Piece::King.new("white", "e1") }

    describe "#moves" do

      it "returns an array of legal moves for the King" do
        board.positions[:d1] = $blank
        board.positions[:e2] = Piece::Pawn.new("white", "e2")
        expect(king.moves(board)).to include("d1")
        expect(king.moves(board)).not_to include("e2")
        expect(king.moves(board)).not_to include("e3")
      end

      it "accurately reflects all and only available moves" do
        board.positions[:d1] = $blank
        board.positions[:e2] = $blank
        board.positions[:f1] = $blank
        board.positions[:d2] = Piece::Pawn.new("white", "e2")
        board.positions[:f2] = Piece::Pawn.new("black", "f2")
        expect(king.moves(board)).to include("d1")
        expect(king.moves(board)).to include("e2")
        expect(king.moves(board)).to include("f1")
        expect(king.moves(board)).to include("f2")
        expect(king.moves(board)).not_to include("d2")
      end

      it "doesn't include tiles off the board" do
        expect(king.moves(board)).not_to include("z2")
      end

    end

  end

  describe Piece::Queen do

    let(:queen) { Piece::Queen.new("white","d1") }

    describe "#moves" do

      it "accurately reflects all and only available moves" do
        board.positions[:c2] = Piece::Pawn.new("white", "c2")
        board.positions[:e2] = $blank
        board.positions[:d2] = $blank
        board.positions[:d7] = Piece::Pawn.new("black", "d7")
        expect(queen.moves(board)).to include("g4")
        expect(queen.moves(board)).to include("d3")
        expect(queen.moves(board)).to include("d7")
        expect(queen.moves(board)).not_to include("b3")
        expect(queen.moves(board)).not_to include("e1")
        expect(queen.moves(board)).not_to include("c2")
      end

    end

  end

  describe Piece::Knight do

    let(:knight) { Piece::Knight.new("white", "d4") }

    describe "#moves" do

      it "accurately reflects all and only available moves" do
        board.positions[:b5] = $blank
        board.positions[:f5] = $blank
        board.positions[:b3] = $blank
        board.positions[:c2] = $blank
        board.positions[:e2] = Piece::Pawn.new("white", "e2")
        board.positions[:e6] = Piece::Pawn.new("black", "e6")
        expect(knight.moves(board)).to include("b5")
        expect(knight.moves(board)).to include("f5")
        expect(knight.moves(board)).to include("b3")
        expect(knight.moves(board)).to include("c2")
        expect(knight.moves(board)).to include("e6")
        expect(knight.moves(board)).not_to include("e2")
      end

      it "doesn't include tiles off the board" do
        expect(knight.moves(board)).not_to include("x1")
      end

    end

  end

  describe Piece::Rook do

    let(:rook) { Piece::Rook.new("white","a1") }

    describe "#moves" do

      it "accurately reflects all and only available moves" do
        board.positions[:a5] = Piece::Pawn.new("black", "a5")
        board.positions[:b1] = Piece::Bishop.new("white", "b1")
        board.positions[:a2] = $blank
        expect(rook.moves(board)).to include("a5")
        expect(rook.moves(board)).to include("a3")
        expect(rook.moves(board)).not_to include("b1")
        expect(rook.moves(board)).not_to include("b2")
      end

    end

  end

  describe Piece::Bishop do

    let(:bishop) { Piece::Bishop.new("white","c1") }

    describe "#moves" do

      it "accurately reflects all and only available moves" do
        board.positions[:f4] = Piece::Pawn.new("black", "f4")
        board.positions[:b2] = Piece::Pawn.new("white", "b2")
        board.positions[:d2] = $blank
        expect(bishop.moves(board)).to include("f4")
        expect(bishop.moves(board)).to include("d2")
        expect(bishop.moves(board)).not_to include("a3")
        expect(bishop.moves(board)).not_to include("b2")
        expect(bishop.moves(board)).not_to include("b3")
      end

    end

  end

  describe Piece::Pawn do

    describe "#moves" do

      let(:white_pawn) { Piece::Pawn.new("white","f2") }
      let(:black_pawn) { Piece::Pawn.new("black","f7") }

      it "allows 2 tiles forward in starting position" do
        board.positions[:f3] = $blank
        board.positions[:f4] = $blank
        expect(white_pawn.moves(board)).to include("f3")
        expect(white_pawn.moves(board)).to include("f4")
        expect(white_pawn.moves(board)).not_to include("f5")
      end

      it "allows only 1 tile forward when not in starting position" do
        white_pawn = Piece::Pawn.new("white","g3")
        board.positions[:g4] = $blank
        board.positions[:g5] = $blank
        expect(white_pawn.moves(board)).to include("g4")
        expect(white_pawn.moves(board)).not_to include("g5")
      end

      it "does not allow forward movement into an enemy-occupied tile" do
        board.positions[:f3] = Piece::Queen.new("black","f3")
        board.positions[:g3] = $blank
        expect(white_pawn.moves(board)).not_to include("f3")
      end

      it "allows diagonal movement when capturing" do
        board.positions[:g3] = Piece::Queen.new("black","g3")
        board.positions[:e3] = Piece::Pawn.new("white","e3")
        board.positions[:f3] = $blank
        expect(white_pawn.moves(board)).to include("f3")
        expect(white_pawn.moves(board)).to include("g3")
        expect(white_pawn.moves(board)).not_to include("e3")
      end

      it "works correctly for both black and white" do
        board.positions[:f6] = $blank
        board.positions[:f5] = $blank
        board.positions[:g6] = Piece::Queen.new("white","g6")
        board.positions[:e6] = Piece::Pawn.new("black","e6")
        expect(black_pawn.moves(board)).to include("f5")
        expect(black_pawn.moves(board)).to include("f6")
        expect(black_pawn.moves(board)).to include("g6")
        expect(black_pawn.moves(board)).not_to include("e6")
        expect(black_pawn.moves(board)).not_to include("e7")
        expect(black_pawn.moves(board)).not_to include("f4")
      end

      it "recognizes en passant moves" do
        allow(GameIO).to receive(:give_output).and_return("")
        white_pawn.position = "f5"
        board.positions[:f5] = white_pawn
        black_pawn.position = "g5"
        board.positions[:g5] = black_pawn
        expect(board.en_passant?(white_pawn)).to eq(true)
        expect(white_pawn.moves(board)).to include("g5")
      end

    end

  end


end