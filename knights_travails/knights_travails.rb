require './binary_tree.rb'

class Chess

  attr_reader :knight, :board

  def initialize
    @knight = Knight.new([1,0])
  end

  def self.squares
    @@squares = [
      [[0,0],[0,1],[0,2],[0,3],[0,4],[0,5],[0,6],[0,7]],
      [[1,0],[1,1],[1,2],[1,3],[1,4],[1,5],[1,6],[1,7]],
      [[2,0],[2,1],[2,2],[2,3],[2,4],[2,5],[2,6],[2,7]],
      [[3,0],[3,1],[3,2],[3,3],[3,4],[3,5],[3,6],[3,7]],
      [[4,0],[4,1],[4,2],[4,3],[4,4],[4,5],[4,6],[4,7]],
      [[5,0],[5,1],[5,2],[5,3],[5,4],[5,5],[5,6],[5,7]],
      [[6,0],[6,1],[6,2],[6,3],[6,4],[6,5],[6,6],[6,7]],
      [[7,0],[7,1],[7,2],[7,3],[7,4],[7,5],[7,6],[7,7]]
    ]
  end

end

class Knight

  attr_reader :possible_moves
  attr_reader :current_position

  def initialize(starting_position)
    @current_position = starting_position
    @possible_moves = get_possible_moves
  end

  def move(destination)
    if @possible_moves.include?(destination)
      @current_position = destination
      get_possible_moves
    else 
      return "Can't move there"
    end
    @current_position
  end

  def get_possible_moves
    @possible_moves = []
    x = @current_position[0]
    y = @current_position[1]
    moves = [
      [x-1,y-2], 
      [x-1,y+2], 
      [x-2,y-1], 
      [x-2,y+1], 
      [x+1,y+2], 
      [x+1,y-2], 
      [x+2,y-1], 
      [x+2,y+1]
    ]

    moves.each do |move|
      @possible_moves << move unless not_on_board?(move)
    end  
    @possible_moves
  end

  def not_on_board?(square)
    Chess.squares.each do |row|
      return false if row.include?(square)
    end
    return true
  end

end

game = Chess.new
p game.knight.possible_moves
game.knight.move([2,2])
p game.knight.possible_moves


# tree = Node.build_tree(board.squares)

# p game
# p board.squares[3][3]
# p tree