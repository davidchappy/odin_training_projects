require 'csv'
require 'sunlight/congress'
require 'erb'

Sunlight::Congress.api_key = "3bdf95dfdfde4a428c4598e8a424cdc4"


def validate_zip(zipcode)
  zipcode.to_s.rjust(5,"0")[0..4]
end

def legislators_by_zip(zipcode)
  legislators = Sunlight::Congress::Legislator.by_zipcode(zipcode)
  
  # legislator_names = legislators.collect do |legislator|
  #   "#{legislator.first_name} #{legislator.last_name}"
  # end.join(", ")
end

def save_thank_you_letter(id, personal_letter)
  Dir.mkdir("output") unless Dir.exists? "output"

  filename = "output/thanks_#{id}.html"

  File.open(filename, 'w') do |file|
    file.puts personal_letter
  end
end

form_letter = File.read "form_letter.erb"
erb_template = ERB.new form_letter

contents = CSV.open "event_attendees.csv", headers: true, header_converters: :symbol

contents.each do |row|
  id = row[0]
  name = row[:first_name]
  zipcode = validate_zip(row[:zipcode])
  legislators = legislators_by_zip(zipcode)

  personal_letter = erb_template.result(binding)

  save_thank_you_letter(id, personal_letter)
end

