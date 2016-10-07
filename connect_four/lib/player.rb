class Player

  attr_reader :name
  attr_accessor :color

  def initialize(name)
    @name = name
    @color = nil
  end

  def choose
    GameIO.give_output("Where will you place your token? (a - g): ", "print")
    GameIO.get_input.downcase
  end

end