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
# puts String.colors

if !ARGV[0].nil? && ARGV[0].downcase == "start"
  Game.start
  ARGV.clear
  STDOUT.flush
elsif !ARGV[0].nil?
  puts "Please include 'start' like this: 'ruby [file-name] start'"
end

