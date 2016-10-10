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

end