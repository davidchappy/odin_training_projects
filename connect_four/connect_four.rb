require './lib/game.rb'
require './lib/player.rb'
require './lib/game_io.rb'
require 'colorize'

$blank_spot = "-"

if !ARGV[0].nil? && ARGV[0].downcase == "start"
  Game.start
  ARGV.clear
  STDOUT.flush
elsif !ARGV[0].nil?
  puts "Please include 'start' like this: 'ruby [file-name] start'"
end