class Game

  attr_reader :current_turn, :game_code, :codebreaker, :codemaker, :total_score, :match_count

  def self.start(roles)
    @players ||= {}
    human = Human.create("Player")
    ai = Ai.new("Computer")
    if roles == "b"
      @players[:codebreaker] = human
      @players[:codemaker] = ai
    elsif roles == "m"
      @players[:codebreaker] = ai
      @players[:codemaker] = human
    elsif roles == "switch"
      @players[:codebreaker], @players[:codemaker] = @players[:codemaker], @players[:codebreaker]
    end
    @current_match = Game.new(@players)
  end

  def self.match_count
    @@match_count
  end

  def self.current_match
    @current_match
  end

  def initialize(players={})
    @@match_count ||= 0
    @@match_count += 1

    @@total_score ||= { human: 0, ai: 0 }

    @codebreaker = players[:codebreaker]
    @codemaker = players[:codemaker]
    @game_code = @codemaker.generate_code

    @board = Board.startup
    @current_turn = 0

    process_turns
  end

  def code
    @game_code
  end

  def process_turns
    while @current_turn < 12
      @current_turn += 1
      @codemaker.score += 1
      guess = @codebreaker.guess
      if @codemaker.is_a?(Human)
        @board.notify_guess(guess)
      end
      result = process_answer(guess)
      if result == "Correct"
        @board.print_answers
        end_match
      end
      @board.print_answers
    end
    end_match
  end

  def process_answer(answer)
    # Tell board to add this answer for output
    @board.answers << answer

    # set up the answer and code as arrays for comparison
    @answer_array = answer.split("")
    @code_array = code.split("")

    # return feedback
    bagels = count_pegs("bagels")
    picos = count_pegs("picos")
    fermis = count_pegs("fermis")    
    feedback = {bagels: bagels, picos: picos, fermis: fermis}
    @board.print_feedback(feedback, @codemaker)

    if answer == code
      puts "The answer was correct!"
      return "Correct"
    end
  end

  def count_pegs(pegs)
    result = 0

    case pegs
    when "bagels"
      @answer_array.each_with_index do |number, index| 
        if @code_array.include?(number) && @answer_array[index] == @code_array[index]
          # remove bagels from answer and code for the remaining two pegcounts (picos/fermis)
          @answer_array[index] = nil
          @code_array[index] = nil
          result += 1

          if @codebreaker.is_a?(Ai) 
            puts "Yep I'm ai"
            @codebreaker.correct_guesses[index] = number
            p @codebreaker.correct_guesses
          end
          
        end
      end
    when "picos"
      # get counts of each digit in code and answer (nil where bagels were)
      code_counts = @code_array.inject(Hash.new(0)) { |total, e| total[e] += 1 ;total}
      answer_counts = @answer_array.inject(Hash.new(0)) { |total, e| total[e] += 1 ;total}
      answer_counts.each do |number,value|
        if number != nil && code_counts.has_key?(number)
          result += 1
          code_counts[number] -= 1
          answer_counts[number] -= 1
          if code_counts[number] == 0
            code_counts[number] = nil
          end
          if answer_counts[number] == 0
            answer_counts[number] = nil
          end
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

  def end_match
    if @codemaker.is_a?(Human)
      @@total_score[:human] += @codemaker.score
    else
      @@total_score[:ai] += @codemaker.score
    end

    puts "Secret Code: #{@game_code}"

    if @@match_count % 2 == 0
      if @@total_score[:human] == @@total_score[:ai]
        current_winner = "Tied"
      else
        current_winner = @@total_score[:human] > @@total_score[:ai] ? "Player" : "Computer"
      end
      @board.print_match_result(@codemaker, @codebreaker, current_winner)
      start_again
    else 
      @board.print_match_result(@codemaker, @codebreaker)
      Game.start("switch")
    end
  end

  def start_again
    @board.print_divider
    print "Play again? (Y/n) "
    choice = gets.chomp
    @board.print_divider
    if choice.downcase == "n"
      exit
    else
      Game.start($player_pref)
    end
  end

end