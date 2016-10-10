# -*- encoding : utf-8 -*-
class Player

  attr_reader :name

  def initialize(num, color)
    @name = GameIO.request_player_name(num, color)
  end

end