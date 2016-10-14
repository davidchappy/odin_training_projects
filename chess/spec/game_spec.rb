# -*- encoding : utf-8 -*-
require './chess.rb'

describe Game do

  let(:game) { Game.new }

  describe "#set_starting_player" do

    let(:player) { game.set_starting_player }

    it "randomly determines a starting player" do
      expect(player).to be_a(Player)
      expect([game.player1, game.player2]).to include(player)
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

  describe "#check?" do

    let(:board) do
      board = Board.new
      board.positions[:e1] = Piece::King.new("white", "e1")
      board.positions[:d2] = $blank
      board.positions[:e2] = $blank
      board.positions[:c3] = Piece::Queen.new("black", "c3") 
      board
    end

    it "returns true if other player has put @current_player in check" do
      game.board = board
      game.current_player = game.player1
      expect(game.check?).to eq(true)
    end

  end

end
