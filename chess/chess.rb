# -*- encoding : utf-8 -*-
require './lib/chess_helpers.rb'
require './lib/game.rb'
require './lib/saver.rb'
require './lib/board.rb'
require './lib/game_io.rb'
require './lib/player.rb'
require './lib/piece.rb'
require 'colorize'

$blank = " "

if !ARGV[0].nil? && (ARGV[0].downcase == "start" || ARGV[0].downcase == "s")
  Game.start
  ARGV.clear
  STDOUT.flush
else
  GameIO.give_output("Please include 'start' like this: 'ruby chess.rb start'")
end

