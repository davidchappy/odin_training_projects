require './chess.rb'

describe GameIO do
    describe ".give_output" do
      it "should output a message for the user" do
        @output = StringIO.new
        GameIO.give_output("test message", "puts", @output)
        expect(@output.string).to eq("test message\n") 
      end
    end

    describe ".get_input" do
      it "should return the user's input" do
        @input = StringIO.new("test info\n")
        @input_received = GameIO.get_input(@input)
        expect(@input_received).to eq("test info") 
      end
    end

    describe ".print_captured" do

      let(:board) { Board.new }

      it "should list captured pieces by color in comma-separated lists" do
        board.captured << Piece::Pawn.new("white", "")
        board.captured << Piece::Queen.new("white", "")
        board.captured << Piece::Rook.new("black", "")
        board.captured << Piece::Knight.new("black", "")

        expect(GameIO.print_captured(board.captured)).to include("White: ")
        expect(GameIO.print_captured(board.captured)).to include("Black: ")
        expect(GameIO.print_captured(board.captured)).to include("pawn, ")
        expect(GameIO.print_captured(board.captured)).to include("queen")
        expect(GameIO.print_captured(board.captured)).to include("rook, ")
        expect(GameIO.print_captured(board.captured)).to include("knight")
      end

      it "only shows a color if it has captured pieces" do
        board.captured << Piece::Knight.new("black", "")
        board.captured << Piece::Queen.new("black", "")
        expect(GameIO.print_captured(board.captured)).not_to include("White: ")
        expect(GameIO.print_captured(board.captured)).to include("Black: ")
        expect(GameIO.print_captured(board.captured)).to include("knight")
        expect(GameIO.print_captured(board.captured)).to include("queen")
      end

    end
end