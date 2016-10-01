require './connect_four.rb'

describe Game do

	let(:game) { Game.start }

	context "when initialized" do
		it "has two player objects" do
			expect(game.player1).to be_a(Player)
			expect(game.player2).to be_a(Player)
			expect(game.players.count).to eq(2)
		end

		it "sets a board instance variable" do
			expect(game.board).to_not be_nil
		end
	end

	describe "#start_board" do
		it "returns a hash with 48 keys" do
			expect(game.start_board).to be_a(Hash)
			expect(game.start_board.count).to eq(48)
		end

		it "contains blank spots only" do
			expect(game.start_board[:a1]).to eq("-")
			expect(game.start_board[:c3]).to eq("-")
			expect(game.start_board[:h6]).to eq("-")
			expect(game.start_board[:h7]).to be_nil
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

end

describe Player do

	let(:player) { Player.new("Bob") }

	context "when initialized" do
		it "has a name" do
			expect(player.name).to eq("Bob")
		end
	end

end