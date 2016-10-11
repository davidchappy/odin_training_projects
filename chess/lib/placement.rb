class Placement

  attr_accessor :tile, :parent, :next_placements

  def initialize(tile, parent=nil, next_placements=nil)
    @tile = tile
    @parent = parent
    @next_placements = next_placements
  end

end