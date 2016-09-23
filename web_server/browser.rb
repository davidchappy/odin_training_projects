require 'socket'
require 'json'

host = 'localhost'
port = 2000

print "Want to (g)et a web page or (p)ost something?"
method = gets.chomp.downcase
print "File path (ex: index.html): "
path = gets.chomp.downcase

if method == "g"
  request = "GET /#{path} HTTP/1.0\r\n\r\n"
elsif method == "p"
  print "What's your viking name? "
  name = gets.chomp
  print "What's your viking email? "
  email = gets.chomp.downcase
  params = {:viking => {:name => name, :email => email}}
  body = params.to_json
  request = "POST /#{path} HTTP/1.0\nContent-Length: #{body.size}\r\n\r\n#{body}" 
end

socket = TCPSocket.open(host,port)
socket.print(request)
response = socket.read
headers, body = response.split("\r\n\r\n", 2)
puts headers
puts body