require 'json'
require 'time'
require "./lib/board.rb"
require "./lib/player.rb"
require "./lib/game.rb"
require "./lib/saver.rb"

$load_from_file = false
$turn_limit = 6
$word_limit = 10
$save_path = "saves/"
Dir.mkdir($save_path) unless Dir.exists?($save_path)

def welcome
  puts "Welcome to Hangman. Type letters or words to guess the answer in #{$turn_limit} turns or less!"
  choice = ""
  print "Would you like to (l)oad a saved game or start a (n)ew game? (N/l/q)?"
  choice = gets.chomp.downcase
  case choice
  when "l"
    $load_from_file = true
  when "q"
    exit
  else
  end
end

welcome
Game.new($load_from_file)