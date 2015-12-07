


require 'socket'
require 'openssl'
require 'json'

$token = ""
$state = 0
$serverIP = "140.113.194.85"
$serverPort = 49175
$admin = "admin"

$rsa = OpenSSL::PKey::RSA


$privKey = $rsa.new File.read "priv.pem"
$pubKey = $rsa.new File.read "pubkey.pub"
$header = "00000256"
$tokenprefix = ""

cipher = "\x87\x93\x49\x5c\x5e\xa1\x49\xc1\x1b\x5f\x3d\x06\x51\x1a\x68\x6d\x2f\x15\x9a\x61\x7b\x89\xc5\xc4\x40\x4d\x88\xd0\x7d\xb2\x4e\x84\x89\xaf\xb3\xd8\x4d\x65\x5d\xbf\x90\xef\xb6\xdc\xf0\xcf\x7f\xb7\x51\x1d\x1d\x26\xa2\xb9\xeb\xd4\xe4\x96\x06\x6f\xd4\x92\xa6\x55\x90\xfe\x0a\x7c\x5d\x43\x0d\x15\xdd\xd3\xf0\xbe\x00\xce\xeb\x70\x6b\x9e\xd5\x40\x63\x38\x3d\xa9\x58\x38\x97\x76\x7d\x1c\x37\x09\x4a\x66\x5a\x2b\x07\xdd\x9e\x07\xd4\x6a\x2a\x47\xf7\x2d\x99\x8f\x8d\x22\x62\x33\xa1\x70\x05\x89\x8f\x79\xe3\x7b\x77\x2a\x27\xa6\x42\xeb\x09\x5e\x24\xbd\x98\xb6\xeb\x85\x1b\x33\xc2\x56\x3b\x67\x33\x8d\x78\x09\xc6\xd6\x4a\xed\xc4\xee\x39\xf8\xc6\xa2\xf8\xc3\x49\x94\xe9\xaf\xf6\xcd\xe7\x29\x19\xc8\x3d\xa0\x03\x7f\x77\x44\x24\xef\x3b\x5f\x74\xa2\xa6\x78\xc4\x6b\xf2\x47\x4f\xda\x3d\x2a\xf4\x9d\x6e\x59\x3c\xd5\xb5\x71\xed\x02\xa8\xd1\xbe\x1f\x36\x85\xd8\x2d\xd4\x74\x51\x31\x8b\x48\x7f\x39\x83\x99\xb8\x0e\x0e\x06\x8e\x83\xca\x66\x91\xf5\xa2\xed\x4b\x14\x2d\x40\x69\xa2\x9a\xab\x12\x4a\x0c\x70\x6f\xda\x04\xc5\x49\xbc\xb6\xcc\x8f\x45\xe3\x6c"

# right plaintext
# {"username":"NetworkSecurity","password":"projectissoeasy","isAdmin":false}d86083dccf261011ce3ca716bf2bba2c41a4d4766a275f36434b1484ea68cb04
#puts $privKey.private_decrypt(cipher)
#


# change to admin
def changeAdmin()
	begin
		plainText = $privKey.private_decrypt($token)
	rescue ZeroDivisionError
		puts "error"
		return false
	end
	first = plainText.slice(0,plainText.index("}")+1)
	second = plainText.slice(plainText.index("}")+1,plainText.length-1)
	first = JSON.parse(first)
	first["isAdmin"] = true
	first = JSON.generate(first)
	plainText = first + second
	puts plainText
	$token = $header + $pubKey.public_encrypt(plainText)
	return true
end

def parseMessage()
	if $token.length != 264
		return false
	end
	if $token.include? $header
		$tokenprefix = $token.split($header)[0]
		$token = $token.split($header)[1]
		return true
	else 
		return false
	end
end



server = TCPServer.new 2000 # Server bind to port 2000
loop do
	  client = server.accept    # Wait for a client to connect
	  $token = client.gets
	  if parseMessage() 
		  if changeAdmin()
			  break
		  else
		  end
	  else 
		  puts "token error"
	  end

	  #client.puts "Hello !"
	  #client.puts "Time is #{Time.now}"
	  #client.close
end
server.close

s = TCPSocket.new '140.113.194.85', 49175
s.puts $token
cmd = "first"

while line = s.recv(2048) # Read lines from socket
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
	  #if $state == 2
	  #        $state = 1
	  #end
end

s.close             # close socket when done




#so = TCPSocket.new $serverIP , $serverPort
#so.puts $admin
#
#while line = so.recv(1024)
#	puts line
#end
#so.close

# test uid
# get ticket
# get public key
# de(xx) 



#server = TCPServer.new 2000 # Server bind to port 2000
#loop do
#	  client = server.accept    # Wait for a client to connect
#	  $token = client.gets
#	  puts $token
#	  break
#	  #client.puts "Hello !"
#	  #client.puts "Time is #{Time.now}"
#	  #client.close
#end
#
#
#
#s = TCPSocket.new '140.113.194.85', 49175
#s.puts $token
#
#while line = s.recv(1024) # Read lines from socket
#	  puts line         # and print them
#	  if $state == 0
#		if line.include? "Login Success"
#			$state = 1
#		end
#	  end
#	  if $state == 1
#	          cmd = gets
#	          s.puts cmd
#		  $state = 2
#	  end
#	  if $state == 2
#		  if line.length == 0 
#			  $state = 1
#		  end
#	  end
#end
#
#s.close             # close socket when done
