require "./lib/board.rb"
require "./lib/player.rb"
require "./lib/game.rb"
require "./lib/saves.rb"

load_from_file = false
$turn_limit = 6

def welcome
  puts "Welcome to Hangman. Type letters or words to guess the answer in #{$turn_limit} turns or less!"
  choice = ""
  print "Would you like to (l)oad a saved game or start a (n)ew game? (N/l/q)?"
  choice = gets.chomp.downcase
  case choice
  when "l"
    load_from_file = true
  when "q"
    exit
  else
  end
end

welcome
Game.start(load_from_file)