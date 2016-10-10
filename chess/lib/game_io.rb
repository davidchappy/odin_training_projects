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

end