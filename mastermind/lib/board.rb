class Board

  attr_accessor :answers, :feedback

  def initialize
    @answers = []
    @feedback = []
  end

  def self.startup
    puts "Match No. #{Game.match_count}"
    self.new
  end

  def print_divider
    puts "--------"
  end

  def print_answers
    puts "All answers:"
    @answers.each_with_index do |answer, index|
      i = index + 1
      print i.to_s + ": " + answer 
      puts " -- [#{@feedback[index][:bagels]},#{@feedback[index][:picos]},#{@feedback[index][:fermis]}]"
    end 
    print_divider
  end

  def notify_guess(guess)
    print "The computer guessed #{guess}. Press any key to continue."
    gets.chomp
  end

  def print_feedback(feedback, codemaker)
    @feedback << feedback
    print_divider
    puts "#{codemaker.name}'s answer: "
    puts "Black peg(s) (correct): #{feedback[:bagels].to_s}"
    puts "White peg(s) (wrong place): #{feedback[:picos].to_s}"
    puts "No peg (wrong): #{feedback[:fermis].to_s}"
    print_divider
  end

  def print_match_result(codemaker, codebreaker, current_winner=false)
    print_divider
    if current_winner
      puts "Current winner: #{current_winner}"
    else
      puts "Current Score"
    end
    puts "#{codebreaker.name}: #{codebreaker.score}"
    puts "#{codemaker.name}: #{codemaker.score}"
    print_divider
  end

end