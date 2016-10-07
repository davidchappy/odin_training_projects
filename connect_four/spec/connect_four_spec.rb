require './connect_four.rb'

describe Game do

	let(:game) { Game.new("David", "Kristin") }

	context "when initialized" do
		it "creates two player objects" do
			expect(game.player1).to be_a(Player)
			expect(game.player2).to be_a(Player)
			expect(game.players.count).to eq(2)
		end

    it "sets the players' colors" do
      expect(game.player1.color).to_not eq(game.player2.color)
    end

    it "randomly sets a current_player" do
      expect(game.current_player).to_not be_nil
      expect(game.current_player).to be_a(Player)
    end

    it "starts up the board" do
      expect(game.board).to_not be_nil
      expect(game.board).to be_a(Hash)
    end
	end

  describe "#set_colors" do

    let(:set_colors) { game.set_colors }

    it "randomly determines each player's color" do
      expect(game.player1.color).to_not be_nil
      expect(game.player2.color).to_not be_nil
      expect(game.player1.color).to_not eq(game.player2.color)
    end

  end

  describe "#set_starting_player" do

    let(:player) { game.set_starting_player }

    it "randomly determines a starting player" do
      expect(player).to be_a(Player)
      expect(game.players).to include(player)
    end

    it "sets a current_player instance variable" do
      expect(game.current_player).to_not be_nil
    end
  end

  describe "#switch_players" do

    it "sets current_player to next player" do
      expect(game.switch_players(game.current_player)).to be_a(Player)
      expect(game.switch_players).to_not eq(game.current_player)
    end

  end

  describe "#add_token_to_board" do

    before do
      $stdin = "a1"
    end

    after do
      $stdin = STDIN
    end

    let(:choice) { game.current_player.choose }
    let(:new_board) { game.add_token_to_board(choice) }

    it "requests player's choice" do
      expect(game.board.keys).to include(choice)
      expect(choice).to be_a(Symbol)
    end

    it "updates and returns @board" do
      old_board = game.board
      expect(game.add_token_to_board(choice)).to be_a(Hash)
      expect(old_board[:choice]).to_not eq(new_board[:choice])
    end

  end

	describe "#start_board" do
		it "returns a hash with 42 keys" do
			expect(game.start_board).to be_a(Hash)
			expect(game.start_board.count).to eq(42)
		end

		it "contains blank spots only" do
			expect(game.start_board[:a1]).to eq($blank_spot)
			expect(game.start_board[:c3]).to eq($blank_spot)
			expect(game.start_board[:g5]).to eq($blank_spot)
			expect(game.start_board[:g7]).to be_nil
		end
	end

	describe "#print_board" do

    let(:output) { game.print_board }

		it "returns a string" do
      expect(output).to be_a(String)
    end

    it "returns at least a full row" do 
      expect(output).to include(game.board.values[0..6].join(" ")) 
    end

	end

end

describe Player do

  let(:game) { Game.new("David", "Kristin") }
	let(:player) { Player.new("Bob") }

	context "when initialized" do
		it "has a name" do
			expect(player.name).to eq("Bob")
		end

    it "has color set to nil" do
      expect(player.color).to be_nil
    end
	end

  describe "#choose" do

    before do
      $stdin = ":a1"
    end

    after do
      $stdin = STDIN
    end

    it "requests user input" do
      expect($stdin).to_not be_nil
    end

  end

end