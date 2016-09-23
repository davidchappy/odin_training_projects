require 'socket'
require 'json'

puts "Running your server. Type Crl+C to quit."

def return_file(path)
  if File.exists?(path)
    return File.read(path)
  else
    return false
  end
end

# Open server
server = TCPServer.open(2000)

loop do
  # Open server
  client = server.accept
  request = client.gets

  # Process request
  request_header, request_body = request.split("\r\n\r\n", 2)
  if request_body
    params = JSON.parse(request_body)
  end
  p request_header
  p params
  method = request_header.split[0]
  path = request_header.split[1][1..-1]
  file = return_file(path)

  case method
  when "GET"
    puts "processing GET request"
    response_body = file
    file_length = response_body.to_s.length
    if response_body == false || response_body == nil
      response_header = "HTTP/1.0 404 Not Found\r\n"
    else
      response_header = "HTTP/1.0 200 OK\r\n"
    end
  when "POST"
    puts "processing POST request"
  else
    puts "I don't recognize that request."
  end

  p response_body

  # Respond
  response_header << "Date: #{Time.now.ctime}\r\n" 
  response_header << "Content-Length: #{file_length.to_s}"
  client.puts response_header
  client.puts ""
  client.puts response_body unless response_body == false

  # Close server
  client.close
end


# Apple.com headers (sample)
# HTTP/1.1 200 OK
# Server: Apache
# Accept-Ranges: bytes
# Content-Type: text/html; charset=UTF-8
# Vary: Accept-Encoding
# Content-Encoding: gzip
# Cache-Control: max-age=516
# Expires: Wed, 21 Sep 2016 16:11:33 GMT
# Date: Wed, 21 Sep 2016 16:02:57 GMT
# Content-Length: 5931
# Connection: keep-alive


