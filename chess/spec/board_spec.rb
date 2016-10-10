# -*- encoding : utf-8 -*-
require './chess.rb'

describe Board do

  let(:board) { Board.new }

  describe "#generate_board" do

    let(:board_tiles) { board.generate_board }

    it "returns an array of board output characters" do
      expect(board_tiles).to be_a(Array)
      expect(board_tiles.length).to eq(18)
    end

    # unable to test actual output because of extra characters added by colorize plugin

  end
  
  describe "#generate_positions" do

    let(:positions) { board.generate_positions }

    it "returns a hash with 64 keys" do
      expect(positions).to be_a(Hash)
      expect(positions.length).to eq(64)
    end

    it "returns blank spots by default" do
      expect(positions.values.all? {|spot| spot == $blank } ).to eq(true)
    end

    #chose not to test the #print_positions helper method

  end

end
