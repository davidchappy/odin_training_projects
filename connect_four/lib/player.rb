class Player

  attr_reader :name
  attr_accessor :color

  def initialize(name)
    @name = name
    @color = nil
  end

  def choose
    GameIO.give_output("Where will you place your token? (a - g): ", "print")
    choice = GameIO.get_input.downcase[0]
    
    unless ('a'..'g').include?(choice)
      GameIO.give_output("Please type one character between a and g.")
      choice = choose
    end
    choice
  end

end