require 'socket'
require 'json'

server = TCPServer.open(2000)
loop do
  Thread.start(server.accept) do |client|
    request = client.read_nonblock(256)

    request_headers, request_body = request.split("\r\n\r\n", 2)
    method = request_headers.split(" ")[0]
    path = request_headers.split(" ")[1][1..-1]

    if File.exist?(path)
      file = File.open(path)

      if method.downcase == "get"
        client.puts "HTTP/1.0 200 OK\n#{Time.now.ctime}\nContent-Length: #{file.size}\r\n\r\n#{file.read}"
      elsif method.downcase == "post"
        params = JSON.parse(request_body)
        output = ""
        params["viking"].each { |k, v| output << "<li>#{k.capitalize}: #{v}</li>" }

        name = params["viking"]["name"]
        File.open("thanks_#{name}.html", "w+") do |f| 
          f.write("#{file.read.gsub("<%= yield %>", output)}") 
        end

        new_file = File.read("thanks_#{name}.html")
        client.puts "HTTP/1.0 200 OK\n#{Time.now.ctime}" \
                    "\nContent-Length: #{new_file.length}\r\n\r\n" \
                    "#{new_file}"
      else
        puts "Not sure what kind of request you're making."
      end
    else
      client.puts "HTTP/1.0 404 Not Found\n#{Time.now.ctime}\r\n\r\n"
    end

    client.close
  end
end


