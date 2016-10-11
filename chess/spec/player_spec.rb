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
    let(:move) { player.take_turn }

    before(:each) do
      allow(GameIO).to receive(:give_output).with("Choose a piece to move by its coordinates (ex: a8): ", "print", StringIO.new)
      allow(GameIO).to receive(:get_input).with(StringIO.new("a8"))
      allow(GameIO).to receive(:give_output).with("Choose a destination by its coordinates (ex: a5): ", "print", StringIO.new)
      allow(GameIO).to receive(:get_input).with(StringIO.new("a8"))
    end

    it "requests a player's move as an array of 2 coordinates" do 
      expect(move).to_not be_nil
      expect(move).to be_a(Array)
      expect(move.length).to eq(2)
      expect(move[0]).to be_a(String)
      expect(move[1]).to be_a(String)
    end

    it "expects both responses to be within the board's tiles" do
      expect(board.positions.keys).to include(move[0].to_sym)
      expect(board.positions.keys).to include(move[1].to_sym)
    end

    it "expects first coordinate to target a piece" do
      expect(board.positions[move[0].to_sym]).to_not eq($blank)
      expect(board.positions[move[0].to_sym]).to be_a(Piece)
    end

    it "expects second coordinate to target a legal move" do
      piece = board.positions[move[0].to_sym]
      expect(piece.legal_moves).to include(move[1])
    end

  end

end