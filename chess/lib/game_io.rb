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
    if king_safe_tiles.compact.length == 0
      output = "You're king cannot move. Try block or capturing your attacker."
    else
      output << "Safe moves: "
      king_safe_tiles.each {|tile| output[1] += tile.to_s + ", " unless tile.nil? } 
      output[1] = output[1].chomp(", ")
      output[2] = "Either move to a safe tile or block/capture the attacker."
    end
    self.give_output(output, "puts", stdout)
    output
  end

  def self.print_turn_update(player, move, board, check=false)
    piece = board.find_piece(move[0])
    destination = move[1]
    output = "Move: #{player.name} moved #{piece.name} to #{destination}"
    self.give_output(output)
  end

  def self.print_finish(winner)
    output = "Game over! #{winner.name} wins!"
    self.give_output(output)
  end

  def self.print_promotion(captures)
    output = "Please choose a captured piece to promote by its number in the list below:\n"
    captures.each_with_index do |capture,index|
      output += (index + 1).to_s + ": " + capture.name + "\n"
    end
    GameIO.give_output(output)
  end

  def self.welcome
   GameIO.give_output("Welcome to Chess! This is a 2-player game and the starting player is chosen randomly.")    
  end

  def self.choose_save(saves)
    if saves == nil || saves == []
      GameIO.give_output("You have no saved games.\nRestarting.") 
      Game.start
    else
      GameIO.give_output("Your saves:")
      saves.each do |save|
        GameIO.give_output "(" + save[:id].to_s + ")" + " - " + Time.at(save[:time]).strftime("%Y-%m-%d %H:%M:%S")
      end
    end
    GameIO.give_output("Type the number of the game you'd like to load: ", "print")
    id = GameIO.get_input
    while id.match(/ˆ[0-9]+$/) == false
      GameIO.give_output("Please type a number: ", "print")
      id = GameIO.get_input
    end
    id
  end

  def self.load?
    GameIO.give_output("Would you like to (l)oad a saved game or start a (N)ew game?", "print")
    choice = GameIO.get_input.downcase
    return true if choice == "l"
    false
  end

  def self.save?
    GameIO.give_output("Want to save your game? (y/N) ", "print")
    response = GameIO.get_input.downcase
    if response == "y"
      GameIO.give_output("Game saved.")
      return true 
    end
    false
  end

end