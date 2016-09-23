require 'socket'
require 'json'

host = 'localhost'
port = 2000

# choose host and port (or nothing for defaults)
# printf "Web host to connect to (blank = localhost:2000): "
# i = gets.chomp.downcase
# unless i == ""
#   host = i
#   port = 80
# end
printf "File path (ex: index.html): "
path = '/' + gets.chomp.downcase

# choose GET or POST
printf "Want to (g)et a web page or (p)ost something?"
method = gets.chomp.downcase
case method
when "g"
  request = "GET #{path} HTTP/1.0\r\n\r\n"
when "p"
  puts "Register for a raid!"
  printf "What's your viking name? "
  name = gets.chomp
  printf "What's your viking email? "
  email = gets.chomp.downcase
  params = {:viking => {:name => name, :email => email}}
  body = params.to_json
  p body

  request = "POST #{path} HTTP/1.0\nContent-Length: #{body.length}\r\n\r\n#{body}" 
else
  puts "Sorry, don't recognize that request type. Closing browser."
  exit
end

p request

socket = TCPSocket.open(host,port)
socket.print(request)
response = socket.read
headers,body = response.split("\r\n\r\n", 2)
print headers
print body