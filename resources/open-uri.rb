require 'open-uri'
url = "http://ruby.bastardsbook.com/files/fundamentals/hamlet.txt"
local_fname = "hamlet.txt"
File.open(local_fname, "w"){ |file| file.write(open(url).read)}

is_hamlet_speaking = false
File.open(local_fname, "r") do |file|
  file.readlines.each do |line|
    if is_hamlet_speaking == true && ( line.match(/^  [A-Z]/) || line.strip.empty? )
      is_hamlet_speaking = false
    end

    is_hamlet_speaking = true if line.match("Ham\.")

    puts line if is_hamlet_speaking == true
  end
end
