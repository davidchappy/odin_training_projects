class Player

  attr_reader :code, :name
  attr_accessor :score

  def initialize(name)
    @score ||= 0
    @name = name
    @code ||= ""
  end

end


class Ai < Player

  attr_accessor :correct_guesses

  def initialize(name)
    super
    @correct_guesses ||= [nil,nil,nil,nil]
  end

  def generate_code
    code = []
    4.times { |r| code << rand(1..6) }
    @code = code.join("") 
    # p "Code: " + @code
    return @code
  end

  def guess
    guess = []
    p @correct_guesses
    @correct_guesses.each_with_index do |number, index| 
      if number == nil
        guess[index] = rand(1..6)
      else
        guess[index] = @correct_guesses[index]
      end
    end
    guess.join("")
  end

end

class Human < Player

  def self.create(player_name=nil)
    if player_name == nil
      print "Your name? "
      player_name = gets.chomp
      puts "Player: " + player_name
    end
    self.new(player_name)
  end

  def guess
    print "Your turn! Choose 4 numbers from 1 to 6: "
    request_input
  end

  def generate_code
    print "Please type a 4-digit secret code that the computer will guess (use only 1-6): "
    request_input
  end

  def request_input
    response = gets.chomp
    while response.length != 4 || !response.match(/^[1-6]+$/)
      print "Please choose 4 numbers between 1 and 6."
      response = gets.chomp
    end
    response
  end

end