require './connect_four.rb'

describe Game do

  let(:game) { Game.new("David", "Kristin") }

  describe "#initialize" do
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

  describe "#row_victory?" do

    it "checks for a row victory" do
      game.board[:a1] = game.current_player.color
      game.board[:b1] = game.current_player.color
      game.board[:c1] = game.current_player.color
      expect(game.row_victory?).to eq(false)

      game.board[:d1] = game.current_player.color
      # game.board[:e1] = "R"
      expect(game.row_victory?).to eq(true)
    end

  end

  describe "#column_victory?" do

     it "checks for a column victory" do
      game.board[:a1] = game.current_player.color
      game.board[:a2] = game.current_player.color
      game.board[:a3] = game.current_player.color
      expect(game.column_victory?).to eq(false)

      game.board[:a4] = game.current_player.color
      expect(game.column_victory?).to eq(true)
    end

  end

  describe "#diagonal_victory?" do

    it "checks for a diagonal victory (top left to bottom right)" do
      game.board[:a1] = game.current_player.color
      game.board[:b2] = game.current_player.color
      game.board[:c3] = game.current_player.color
      expect(game.diagonal_victory?).to eq(false)

      game.board[:d4] = game.current_player.color
      expect(game.diagonal_victory?).to eq(true)
    end

    it "checks for a diagonal victory (bottom left to top right)" do
      game.board[:d1] = game.current_player.color
      game.board[:c2] = game.current_player.color
      game.board[:b3] = game.current_player.color
      expect(game.diagonal_victory?).to eq(false)

      game.board[:a4] = game.current_player.color
      expect(game.diagonal_victory?).to eq(true)
    end

  end

  describe "#board_full?" do

    it "returns true if there are no blank spots left on the board" do
      temp_game = game
      game.board.each { |k,v| temp_game.board[k] = "R" }
      expect(temp_game.board_full?).to eq(true)
    end

  end

  describe "#start_again" do

    let(:temp_game) { instance_double("Game").as_null_object }

    it "asks player whether to quit or restart" do
      temp_game.start_again
      allow(GameIO).to receive(:give_output).with("Play again? (y/N) ").and_return("")
      allow(GameIO).to receive(:get_input).and_return("n")
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

    let(:choice) { "a" }
    let(:new_board) { game.add_token_to_board(choice) }

    it "expects user input to be a column name" do
      column_names = []
      game.board.keys.each_with_index do |spot,index| 
        column_names[index] = spot[0] unless column_names.include?(spot[0])
      end
      expect(column_names).to include(choice)
    end

    it "updates and returns @board" do
      old_spot = game.board[:a6]
      new_spot = new_board[:a6]
      expect(new_board).to be_a(Hash)
      expect(old_spot).to_not eq(new_spot)
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


  describe "#print_welcome" do

    let(:output) { game.print_welcome }

    it "returns at a welcome message" do 
      expect(output).to include("Welcome to Connect Four!") 
    end

    it "gives basic game instructions" do
      expect(output).to include("First to get four consecutive tokens in a row, column or diagonally wins!")
    end

    it "displays each player's color" do
      expect(output).to include("David's color: #{game.player1.color}")
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

  describe "#print_turn_update" do

    let(:output) { game.print_turn_update }

    it "returns who's turn it is" do
      expect(output).to include("It's #{game.current_player.name}'s turn.")
    end

  end

  describe "#print_game_end" do

    context "with a victory parameter" do

      let(:victory_output) { game.print_game_end("victory", game.current_player) }

      it "returns the name of the current_player" do
        expect(victory_output).to include(game.current_player.name)
      end

      it "prints a victory message" do
        expect(victory_output).to include("Congratulations!")
      end

    end

    context "with a draw parameter" do

      let(:draw_output) { game.print_game_end("draw") }

      it "prints a tie message" do
        expect(draw_output).to include("The board is full")
      end

    end

  end

end