# -*- encoding : utf-8 -*-
require './chess.rb'

describe ChessHelpers do

  let(:board) { Board.new }

  describe "#spawn" do

    it "multiplies a string by n times" do
      expect(board.spawn("hello", 3)).to eq("hellohellohello")
    end

  end 

end
