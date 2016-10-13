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

  def self.print_board(board)
    self.give_output(board)
    captured = ["Captured pieces: "]
    board.positions.each {|p| captured << p.name if board.is_piece?(p) && p.captured == true }
    captured = captured.join(", ")
    self.give_output(captured, "print")
  end

  def self.print_turn_update(player, move, board, check=false)
    piece = board.find_piece(move[0])
    destination = move[1]
    output = "#{player.name} moved #{piece.name} to #{destination}"
    self.give_output(output)
  end



end