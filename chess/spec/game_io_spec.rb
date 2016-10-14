require 'spec_helper'

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

        expect(GameIO.print_captured(board.captured, StringIO.new)).to include("White: ")
        expect(GameIO.print_captured(board.captured, StringIO.new)).to include("Black: ")
        expect(GameIO.print_captured(board.captured, StringIO.new)).to include("pawn, ")
        expect(GameIO.print_captured(board.captured, StringIO.new)).to include("queen")
        expect(GameIO.print_captured(board.captured, StringIO.new)).to include("rook, ")
        expect(GameIO.print_captured(board.captured, StringIO.new)).to include("knight")
      end

      it "only shows a color if it has captured pieces" do
        board.captured << Piece::Knight.new("black", "")
        board.captured << Piece::Queen.new("black", "")
        expect(GameIO.print_captured(board.captured, StringIO.new)).not_to include("White: ")
        expect(GameIO.print_captured(board.captured, StringIO.new)).to include("Black: ")
        expect(GameIO.print_captured(board.captured, StringIO.new)).to include("knight")
        expect(GameIO.print_captured(board.captured, StringIO.new)).to include("queen")
      end

    end

    describe ".print_check" do

      let(:game) do
        game = Game.new 
        game.current_player = game.player1
        game
      end
      let(:board) { game.board }
      let(:print_check) { GameIO.print_check(game.current_player, board.king_safe_tiles(game.current_player, game.switch_players), StringIO.new) }

      it "should list captured pieces by color in comma-separated lists" do
        board.positions[:d2] = $blank
        board.positions[:e2] = $blank
        board.positions[:e1] = Piece::King.new("white", "e1")
        board.positions[:c3] = Piece::Queen.new("black", "c3")

        expect(print_check).to include("#{game.current_player.name} is in check!")
        expect(print_check).to include("Safe moves: e2")
      end

    end
end