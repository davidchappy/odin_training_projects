require './chess.rb'

describe Piece do

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


end