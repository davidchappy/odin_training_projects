require './tic_tac_toe.rb'

describe Game do

  before(:each) do 
    player = Player.new("David")
    @s = player.symbol = "o"
    Game.current_player = player
    Game.board = Board.start_board
  end

  context "when checking for victory" do
    it "can grant a row victory" do
      Board.board[:a1] = @s; Board.board[:a2] = @s; Board.board[:a3] = @s
      Board.board[:b2] = "x"; Board.board[:b2] = "x"; Board.board[:c3] = "x"
      expect(Board.column_victory?).to eq(false)
      expect(Board.diagonal_victory?).to eq(false)
      expect(Board.row_victory?).to eq(true)
    end

    it "can grant a column victory" do
      Board.board[:a1] = @s; Board.board[:b1] = @s; Board.board[:c1] = @s
      Board.board[:a2] = "x"; Board.board[:b2] = "x"; Board.board[:c3] = "x"
      expect(Board.diagonal_victory?).to eq(false)
      expect(Board.row_victory?).to eq(false)
      expect(Board.column_victory?).to eq(true)
    end

    it "can grant a diagonal victory" do
      Board.board[:a1] = @s; Board.board[:b2] = @s; Board.board[:c3] = @s
      Board.board[:a3] = "x"; Board.board[:b1] = "x"; Board.board[:c1] = "x"; Board.board[:a2] = "x"
      expect(Board.row_victory?).to eq(false)
      expect(Board.column_victory?).to eq(false)
      expect(Board.diagonal_victory?).to eq(true)
    end
  end

  context "when there's no victory and board is full" do
    it "ends the game in a draw" do
      symbols = ["x", "o"]
      Board.board.each { |k,v| Board.board[k] = symbols.sample } 
      expect(Board.full?).to be(true)
    end
  end

  describe ".set_players" do
    before do
      Game.set_players
    end

    it "creates two new Player objects" do
      expect(Game.player1).to_not be_nil
      expect(Game.player2).to_not be_nil
    end

    it "assigns unique symbols to each player" do
      expect(Game.player1.symbol).to_not be_nil
      expect(Game.player2.symbol).to_not be_nil
      expect(Game.player1.symbol).to_not equal(Game.player2.symbol)
    end
  end

  # describe ".process_turn" do

  #   before do
  #     $stdin = StringIO.new("")
  #   end

  #   after do
  #     $stdin = STDIN
  #   end

  #   it "controls game play by calling several methods each turn" do
  #     board = class_double("Board", :board => Board.board).as_stubbed_const
  #     game = class_double("Game")
  #     current_player = instance_double("Player", :name => "Jim", :symbol => "x")
  #     Game.current_player = current_player
  #     expect(board).to receive(:board)
  #     expect(board).to receive(:board=)
  #     expect(board).to receive(:spot_taken?)
  #     expect(board).to receive(:print_board)
  #     expect(board).to receive(:row_victory?)
  #     expect(board).to receive(:column_victory?)
  #     expect(board).to receive(:diagonal_victory?)
  #     expect(board).to receive(:full?)

  #     expect(game).to receive(:check_for_game_over).and_return(false)
  #     expect(game).to receive(:switch_players)

  #     expect(current_player).to receive(:take_turn).and_return(false)

  #     Game.process_turn("a1")
  #   end
  # end


end