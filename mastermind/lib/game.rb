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
  
    feedback = count_pegs
    @board.print_feedback(feedback, @codemaker)

    if answer == code
      puts "The answer was correct!"
      return "Correct"
    end
  end

  def count_pegs
    results = {bagels: 0, picos: 0, fermis: 0}
    pegs_counted = 0
    duplicates = []

    # get counts of each digit in code and answer arrays
    code_counts = @code_array.inject(Hash.new(0)) { |total, e| total[e] += 1 ;total}
    answer_counts = @answer_array.inject(Hash.new(0)) { |total, e| total[e] += 1 ;total}

    # operate on @answer_array until 4 pegs have been counted
    until pegs_counted == 4
      @answer_array.each_with_index do |number, index|
        if @code_array.include?(number)
          if @code_array[index] == number  # add bagels
            pegs_counted += 1
            results[:bagels] += 1
            if @codebreaker.is_a?(Ai) 
              @codebreaker.correct_guesses[index] = number
            end
          else  # add picos  
            results[:picos] += 1 
            pegs_counted += 1 
            if answer_counts[number] > code_counts[number]
              duplicates << number unless duplicates.include?(number)
            end
          end
        else # add fermis
          pegs_counted += 1
          results[:fermis] += 1
        end
      end
    end

    # compensate for picos that were overcounted 
    unless duplicates.nil?
      duplicates.each do |duplicate|
        code_counts[duplicate] ||= 0
        difference = answer_counts[duplicate] - code_counts[duplicate]
        results[:picos] -= difference
        results[:fermis] += difference
      end
    end
        
    return results
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