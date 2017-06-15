# -*- encoding : utf-8 -*-
require 'spec_helper'

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

  describe "#check_mate?" do

    let(:board) do
      board = Board.new
      board.positions[:e1] = Piece::King.new("white", "e1")
      board.positions[:d2] = $blank
      board.positions[:e2] = $blank
      board.positions[:c3] = Piece::Queen.new("black", "c3") 
      board
    end

    before do
      game.board = board
      game.current_player = game.player1
    end

    it "returns true if king cannot escape check" do
      expect(game.check_mate?).to eq(false)

      board.positions[:e2] = Piece::Pawn.new("white", "e2")
      board.positions[:b1] = $blank
      board.positions[:b2] = $blank
      game.board = board
      game.current_player = game.player1
      expect(game.check_mate?).to eq(true)
    end

    it "returns false if king another piece can protect the king" do
      expect(game.check_mate?).to eq(false)

      board.positions[:e2] = Piece::Pawn.new("white", "e2")
      # block the attacker
      board.positions[:c1] = $blank
      board.positions[:d2] = Piece::Bishop.new("white", "d2")
      game.board = board
      game.current_player = game.player1
      expect(game.check_mate?).to eq(false)
    end

  end

end
