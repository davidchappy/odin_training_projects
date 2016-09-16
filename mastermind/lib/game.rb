class Game

  def self.start
    Board.startup
    @human = Human.create("Human Player")
    @ai = Ai.new("Computer")
    @current_turn = 0
    @human.guess
  end

  def self.human
    @human
  end

  def self.code
    @ai.code
  end

  def self.process_turn(choice)
    @current_turn += 1
    @ai.score += 1
    result = process_answer(choice)
    if result == "Correct"
      @human.score = 12
      end_match
    elsif @current_turn == 12
      end_match
    end
    Board.print_answers
    @human.guess
  end

  def self.process_answer(answer)
    # Tell board to add this answer for output
    Board.answers << answer

    # set up the answer and code as arrays for comparison
    @answer_array = answer.split("")
    @code_array = code.split("")

    if answer == code
      puts "You got it right!"
      return "Correct"
    else # return feedback
      bagels = count_pegs("bagels")
      picos = count_pegs("picos")
      fermis = count_pegs("fermis")
      
      feedback = {bagels: bagels, picos: picos, fermis: fermis}
      Board.print_feedback(feedback, @ai)
    end
  end

  def self.count_pegs(pegs)
    result = 0

    case pegs
    when "bagels"
      @answer_array.each_with_index do |number, index| 
        if code.include?(number) && @answer_array[index] == code[index]
          # remove bagels from answer and code for the remaining two pegcounts (picos/fermis)
          @answer_array[index] = nil
          @code_array[index] = nil
          result += 1
        end
      end
    when "picos"
      # get counts of each digit in code and answer (nil where bagels were)
      code_counts = @code_array.inject(Hash.new(0)) { |total, e| total[e] += 1 ;total}
      answer_counts = @answer_array.inject(Hash.new(0)) { |total, e| total[e] += 1 ;total}
      @answer_array.each do |number|
        if number != nil && code_counts.has_key?(number) && code_counts[number] >= answer_counts[number]
          result += 1
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

end