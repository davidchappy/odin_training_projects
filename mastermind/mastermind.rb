require "./lib/board.rb"
require "./lib/players.rb"
require "./lib/game.rb"

puts "Welcome to Mastermind! The code-breaker's goal is to guess the secret 4-digit code (#s 1-6) in 12 turns or less."
answer = ""
while %w(b m q).include?(answer) == false
  print "Would you like to be the code(b)reaker or code(m)aker [or (q)uit]? (b/m/q): "
  answer = gets.chomp.downcase
  if answer == "q"
    puts "Bye!"
    exit
  end
end

$player_pref = answer

Game.start($player_pref)