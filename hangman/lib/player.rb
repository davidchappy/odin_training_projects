class Player

  def initialize(current_match)
    @game = current_match
  end

  def guess
    print "Guess a (w)ord or a (l)etter (any other key)? "
    response = gets.chomp.downcase
    case response
    when "w"
      word = guess_word
      return [word, "w"]
    else
      letter = guess_letter
      return [letter, "l"]
    end
  end

  def guess_letter
    response = request_input
    if response.length > 1
      puts "Your choice (truncated): #{response[0]}"
    end
    while @game.player_guesses[:letters].include?(response[0]) || @game.player_guesses[:misses].include?(response[0])
      puts "You've already guessed that — try again."
      response = request_input 
    end
    response
  end

  def guess_word
    answer = @game.word
    response = request_input

    while response.length != answer.length
      puts "Hint: your word should be #{answer.length} characters in length."
      response = request_input
    end
    response
  end

  def request_input
    print "Please type your answer: "
    response = gets.chomp.downcase
    while !response.match(/^[a-zA-Z]+$/)
      print "Please type only letters a-z."
      response = gets.chomp.downcase
    end
    response
  end

  def save?
    print "Want to save your game? (y/N) "
    response = gets.chomp.downcase
    case response
    when "y"
      return true
    else
      return false
    end
  end

end