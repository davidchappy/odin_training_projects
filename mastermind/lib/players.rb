class Player

end


class Ai < Player

  attr_reader :code, :name
  attr_accessor :score

  def initialize(name)
    @code = generate_code
    @score = 0
    @name = name
  end

  def generate_code
    code = []
    4.times { |r| code << rand(1..6) }
    @code = code.join("") 
    # p "Code: " + @code
    return @code
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
      puts "Player: " + player_name
    end
    Board.print_divider
    self.new(player_name)
  end

  def guess
    print "Your turn! Choose 4 numbers from 1 to 6: "
    choice = gets.chomp
    unless choice.length == 4 && choice.match(/^[1-6]+$/)
      puts "Please choose 4 numbers between 1 and 6."
      guess
    end
    Game.process_turn(choice)
  end

end