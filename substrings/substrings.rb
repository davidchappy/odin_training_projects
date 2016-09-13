dictionary = ["below","down","go","going","horn","how","howdy","it","i","low","own","part","partner","sit"]

def substrings(word, dictionary)
  results = {}
  word.downcase!
  dictionary.each do |entry|
    if word.include?(entry)
      sub_count = word.scan(/(?=#{entry})/).count
      results[entry] = sub_count
    end
  end
  results
end

p substrings("Howdy partner, sit down! How's it going?", dictionary)