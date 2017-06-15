# Overarching "game" class to hold board and piece info
class Chess

  attr_reader :knight

  def initialize
    @knight = Knight.new([3,3])
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

  def self.not_on_board?(placement)
    Chess.squares.each do |row|
      return false if row.include?(placement.square)
    end
    return true
  end

end

# Object that represents a square, useful for establishing path relationships
class Placement

  attr_accessor :square, :parent, :next_placements

  def initialize(square, parent=nil, next_placements=nil)
    @square = square
    @parent = parent
    @next_placements = next_placements
  end

end

class Knight

  attr_accessor :current_position

  def initialize(starting_position)
    @current_position = Placement.new(starting_position)
    @current_position.next_placements = get_possible_moves_for(@current_position)
  end

  def move(destination, start=@current_position)
    possible = @current_position.next_placements.collect { |p| p.square }
    if possible.include?(destination)
      @current_position = @current_position.next_placements.find { |e| e.square == destination }
      @current_position.next_placements = get_possible_moves_for(@current_position) 
    else 
      puts "Can't move there"
    end
    @current_position
  end

  # Helper that takes a Placement object and returns array of Placements that can be moved to
  def get_possible_moves_for(position)
    possible = []
    x = position.square[0]
    y = position.square[1]
    moves = [
      Placement.new([x-1,y-2], position), 
      Placement.new([x-1,y+2], position), 
      Placement.new([x-2,y-1], position), 
      Placement.new([x-2,y+1], position), 
      Placement.new([x+1,y+2], position), 
      Placement.new([x+1,y-2], position), 
      Placement.new([x+2,y-1], position), 
      Placement.new([x+2,y+1], position)
    ]
    moves.each do |move|
      possible << move unless Chess.not_on_board?(move)
    end
    possible
  end

  # Method to find shortest route
  def calculate_moves(destination)
    path = []
    queue = [@current_position]
    # thanks to https://github.com/thomasjnoe/knight-moves for help with this visited concept
    visited = []

    return "You're already there" if @current_position.square == destination

    until queue.empty? 
      current_move = queue.shift
      visited << current_move

      if current_move.square == destination
        path_move = current_move
        until path_move == @current_position
          path.unshift(path_move.square)
          path_move = path_move.parent
        end
        path.unshift(@current_position.square)
        puts "You made it in #{(path.length - 1).to_s} moves. Here's your path: "
        path.each do |s|
          p s
        end
        return path
      end

      current_move.next_placements = get_possible_moves_for(current_move).select { |move| !visited.include?(move) } 

      current_move.next_placements.each do |placement|
        queue << placement
        visited << placement
      end
    end
  end

end

game = Chess.new
game.knight.calculate_moves([4,3])