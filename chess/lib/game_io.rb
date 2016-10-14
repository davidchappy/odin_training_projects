# -*- encoding : utf-8 -*-
class GameIO

  def self.give_output(output_message, format="puts", stdout=$stdout)
    case format
    when "print"
      stdout.print output_message
    else
      stdout.puts output_message
    end
  end

  def self.get_input(stdin=$stdin)
    stdin.gets.chomp
  end

  def self.request_player_name(num, color)
    self.give_output("Player #{num.to_s} (#{color}): what's your name? ", "print")
    self.get_input
  end

  def self.print_board(board_output)
    self.give_output(board_output)
  end

  def self.print_captured(captured, stdout=$stdout)
    if captured.length >= 1 
      output = ["Captured pieces: "]
      if captured.select{|p| p if p.color == "white"}.length >= 1
        white = captured.select{|p| p if p.color == "white"}
        output << "White: "
        white.each {|p| output[1] += p.name + ", " unless p.nil?}
        output[1] = output[1].chomp(", ")
      end
      if captured.select{|p| p if p.color == "black"}.length >= 1
        black = captured.select{|p| p if p.color == "black"}
        output << "Black: "
        black.each {|p| output[-1] += p.name + ", " unless p.nil?}
        output[-1] = output[-1].chomp(", ")
      end
      self.give_output(output, "puts", stdout)
      output.join("\n")
    end
  end

  def self.print_check(current_player, king_safe_tiles, stdout=$stdout)
    output = ["#{current_player.name} is in check!"]
    output << "Safe moves: "
    king_safe_tiles.each {|tile| output[1] += tile.to_s + ", " unless tile.nil? } 
    output[1] = output[1].chomp(", ")
    self.give_output(output, "puts", stdout)
    output
  end

  def self.print_turn_update(player, move, board, check=false)
    piece = board.find_piece(move[0])
    destination = move[1]
    output = "#{player.name} moved #{piece.name} to #{destination}"
    self.give_output(output)
  end

  def self.print_finish(winner)
    output = "Game over! #{winner} wins!"
    self.give_output(output)
  end

end