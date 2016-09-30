class CeaserCipher

  def self.cipher(string, shift)
    unless string.is_a?(String)
      return "Input not valid - please use text characters only"
    end
    ciphered_words = []
    excluded = (0..64).to_a.concat (91..96).to_a.concat (123..127).to_a
    string.split(" ").each do |word|
      new_word = []
      word.split("").each do |letter|
        capitalized = false
        value = letter.ord
        if value.between?(65, 90) 
          capitalized = true
          value = value + 32
        end
        unless excluded.include?(value)
          value = value + shift 
          if value > 122
            value = value - 26
          end
          if capitalized == true
            value = value - 32
          end
          letter = value.chr
        end
        new_word << letter
      end
      ciphered_words << new_word.join
    end
    ciphered_string = ciphered_words.join(' ')
  end

end

CeaserCipher.cipher("Cipher ThiZ String Will ya?", 5)