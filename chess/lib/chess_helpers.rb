# -*- encoding : utf-8 -*-
module ChessHelpers

  def icon_white(character)
    character.encode('utf-8').colorize(:white)
  end

  def icon_black(character)
    character.encode('utf-8').colorize(:blue)
  end

  def spawn(char, num)
    output = ""
    num.times do |i|
      output << char
    end 
    output
  end

  def fill_row(num, content, array, letters=("a".."h"))
    letters.to_a.each do |letter|
      array[(letter + num.to_s).to_sym] = content
    end
  end

end
