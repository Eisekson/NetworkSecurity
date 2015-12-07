


require 'socket'

$token = ""

server = TCPServer.new 2000 # Server bind to port 2000
loop do
	  client = server.accept    # Wait for a client to connect
	  $token = client.gets
	  puts $token
	  break
	  #client.puts "Hello !"
	  #client.puts "Time is #{Time.now}"
	  #client.close
end

$state = 0


s = TCPSocket.new '140.113.194.85', 49175
s.puts $token
cmd = "first"

while line = s.recv(1024) # Read lines from socket
	  puts line         # and print them
	  if $state == 0
		if line.include? "Login Success"
			$state = 1
			next
		end
	  end
	  if $state == 1
		  if line.include? cmd
			  next
		  end
	          cmd = gets
	          s.puts cmd
	  end
end

s.close             # close socket when done
