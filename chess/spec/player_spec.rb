require './chess.rb'

describe Player do

  let(:game) { Game.new }
  let(:player) { Player.new(1, "white", "Bob") }

  context "when initialized" do

    it "has a color" do
      expect(player.color).to eq("white")
    end

    it "has a number" do
      expect(player.num).to eq(1)
    end

    it "has a name pre-programmed or requested from player" do
      expect(player.name).to eq("Bob")

      expect(GameIO).to receive(:request_player_name).with(1,"white")
      player_new = Player.new(1,"white")
    end

  end

  describe "#take_turn" do

    let(:board) { Board.new }
    let(:move) { player.take_turn(board) }
    let(:gameio) { class_double("GameIO") }

    before(:each) do
      allow(GameIO).to receive(:give_output)
      allow(GameIO).to receive(:get_input).and_return("a2,a3")
    end

    it "requests a player's move as an array of 2 coordinates" do 
      expect(GameIO).to receive(:give_output).with("It's #{player.name}'s (#{player.color}) turn.\nChoose a valid piece and destination separated by a comma (ex: a2,a3): ", "print").and_return("")
      expect(GameIO).to receive(:get_input).and_return("a2,a3")
      expect(move).to be_a(Array)
      expect(move.length).to eq(2)
      expect(move[0]).to be_a(String)
    end

    it "expects both responses to be within the board's tiles" do
      expect(GameIO).to receive(:give_output).with("It's #{player.name}'s (#{player.color}) turn.\nChoose a valid piece and destination separated by a comma (ex: a2,a3): ", "print").and_return("")
      expect(GameIO).to receive(:get_input).and_return("a2,a3")
      expect(board.positions.keys).to include(move[0].to_sym)
      expect(board.positions.keys).to include(move[1].to_sym)
    end

    it "expects first coordinate to target a piece" do
      expect(GameIO).to receive(:give_output).with("It's #{player.name}'s (#{player.color}) turn.\nChoose a valid piece and destination separated by a comma (ex: a2,a3): ", "print").and_return("")
      expect(GameIO).to receive(:get_input).and_return("a2,a3")
      expect(board.positions[move[0].to_sym]).to_not eq($blank)
      expect(board.positions[move[0].to_sym]).to be_a(Piece)
    end

    it "expects second coordinate to target a legal move" do
      expect(GameIO).to receive(:give_output).with("It's #{player.name}'s (#{player.color}) turn.\nChoose a valid piece and destination separated by a comma (ex: a2,a3): ", "print").and_return("")
      expect(GameIO).to receive(:get_input).and_return("a2,a3")
      piece = board.positions[move[0].to_sym]
      expect(piece.possible_move?(move[1], board)).to be(true)
    end

  end

end