class Game

  attr_reader :winner
  attr_accessor :current_turn, :human

  def self.start
    Board.print_start
    @human = Human.create("David")
    @ai = Ai.new("Ai")
    @current_turn = 0
    @human.guess
  end
  
  def self.advance_turn
    @current_turn += 1
    @ai.score += 1
  end

  def self.process_turn(choice)
    advance_turn
    result = @ai.process_answer(choice)
    if result == "Correct"
      @human.score = 12
      end_match
    elsif @current_turn == 12
      end_match
    end
    Board.print_answers
    @human.guess
  end

  def self.end_match
    winner = @ai.score > @human.score ? @ai : @human
    Board.print_result(winner, @ai.score, @human.score)
    start_again
  end

  def self.start_again
    Board.print_divider
    print "Play again? (Y/n) "
    choice = gets.chomp
    Board.print_divider
    if choice.downcase == "n"
      exit
    else
      Game.start
    end
  end

  def self.human
    @human
  end

end


class Player


  def score
    @score
  end

end


class Ai < Player

  attr_reader :code, :name
  attr_accessor :score

  def initialize(name)
    @code = generate_code
    @score = 0
    @name = name
  end

  def name
    @name
  end

  def generate_code
    code = []
    4.times { |r| code << rand(1..6) }
    @code = code.join("") 
    # p @code
  end

  def process_answer(answer)
    Board.answers << answer
    @answer_array = answer.split("")
    @code_array = code.split("")
    
    if answer == @code
      puts "You got it right!"
      return "Correct"
    else # provide feedback
      bagels = 0 # correct number in correct place (red peg)
      picos = 0 # correct number in wrong place (white peg)
      fermis = 0 # number not in code

      bagels = count_pegs("bagels")
      picos = count_pegs("picos")
      fermis = count_pegs("fermis")
      
      feedback = {bagels: bagels, picos: picos, fermis: fermis}
      Board.print_feedback(feedback, self)
    end
  end

  def count_pegs(pegs)
    result = 0

    case pegs
    when "bagels"
      @answer_array.each_with_index do |number, index| 
        if code.include?(number) && @answer_array[index] == code[index]
          @answer_array[index] = nil
          @code_array[index] = nil
          result += 1
        end
      end
    when "picos"
      # get counts of each digit in answer (may include nil)
      code_counts = @code_array.inject(Hash.new(0)) { |total, e| total[e] += 1 ;total}
      @answer_array.each_with_index do |number, index|
        if number != nil && code_counts.has_key?(number)
          result = code_counts[number]
        end
      end
    when "fermis"
      @answer_array.each do |number|
        unless number == nil || @code_array.include?(number)
          result += 1
        end
      end
    end
    
    return result
  end

  def code
    @code
  end

end

class Human < Player

  attr_reader :name
  attr_accessor :score

  def initialize(name)
    @score = 0
    @name = name
  end

  def self.create(player_name=nil)
    if player_name == nil
      print "Your name? "
      player_name = gets.chomp
    end
    puts "Player: " + player_name
    self.new(player_name)
  end

  def guess
    print "Choose 4 numbers from 1 to 6: "
    choice = gets.chomp
    unless choice.length == 4 && choice.match(/^[1-6]+$/)
      puts "Please choose 4 numbers between 1 and 6."
      guess
    else
      puts "You guessed: #{choice}"
    end
    
    Game.process_turn(choice)
  end

  def score
    @score
  end

end


class Board

  attr_accessor :answers

  def self.print_start
    @answers = []
    puts "Mastermind!"
    print_divider
  end

  def self.print_divider
    puts "--------"
    puts ""
  end

  def self.print_answers
    puts "Your answers:"
    i = 1
    @answers.each do |answer|
      print i.to_s + ": "
      puts answer
      i += 1
    end 
    print_divider
  end

  def self.answers
    @answers
  end

  def self.print_feedback(feedback, codemaker)
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

Game.start