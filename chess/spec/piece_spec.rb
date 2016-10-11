require './chess.rb'

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

  describe "#legal_move?" do

    let(:pawn) { Piece::Pawn.new("white","a2") }

    it "returns true if input is in the legal_moves variable" do
      expect(pawn.legal_move?("a4")).to eq(true)
      expect(pawn.legal_moves).to include("a4")
    end

    it "returns false if input is not in the legal_moves variable" do
      expect(pawn.legal_move?("b3")).to eq(false)
      expect(pawn.legal_moves).not_to include("b3")
    end

  end

  describe Piece::King do

    let(:king) { Piece::King.new("white", "e1") }

    describe "#get_legal_moves" do

      it "returns an array of legal moves for the King" do
        board.positions[:d1] = $blank
        board.positions[:e2] = Piece::Pawn.new("white", "e2")
        expect(king.get_legal_moves(board)).to include("d1")
        expect(king.get_legal_moves(board)).not_to include("e2")
        expect(king.get_legal_moves(board)).not_to include("e3")
      end

    end

  end


end