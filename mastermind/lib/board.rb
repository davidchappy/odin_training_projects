class Board

  attr_accessor :answers, :feedback

  def self.answers
    @answers
  end

  def self.feedback
    @feedback
  end

  def self.startup
    @answers = []
    @feedback = []
    puts "Mastermind! Try to guess the 4-digit code (#s 1-6) in 12 turns or less."
  end

  def self.print_divider
    puts "--------"
  end

  def self.print_answers
    puts "Your answers:"
    @answers.each_with_index do |answer, index|
      i = index + 1
      print i.to_s + ": " + answer 
      puts " -- [#{@feedback[index][:bagels]},#{@feedback[index][:picos]},#{@feedback[index][:fermis]}]"
    end 
    print_divider
  end

  def self.print_feedback(feedback, codemaker)
    @feedback << feedback
    print_divider
    puts "#{codemaker.name}'s answer: "
    puts "Black peg(s) (correct): #{feedback[:bagels].to_s}"
    puts "White peg(s) (wrong place): #{feedback[:picos].to_s}"
    puts "No peg (wrong): #{feedback[:fermis].to_s}"
    print_divider
  end

  def self.print_result(winner, ai_score, hum_score)
    print_divider
    puts "Winner: #{winner.name}!"
    puts "Ai: #{ai_score}"
    puts "You: #{hum_score}"
  end

end