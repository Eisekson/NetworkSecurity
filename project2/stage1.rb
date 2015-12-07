

require 'packetfu'



projectIP = "140.113.194.85"
$destIP = "140.113.194.85"
$destPort = 49175
$srcIP = "188.166.227.112"
$srcPort = 80


sendArr = Array.new


def savePacket(pkt,fileName) 
	pkt.to_f("./pcap/" + fileName +".pcap")
end

def sendPacket(pkt)
	if pkt.tcp_flags.ack == 265
		pkt.ip_saddr = $srcIP
		pkt.tcp_src = $srcPort
		pkt.ip_daddr = $destIP
		pkt.tcp_dst = $destPort
		puts pkt.payload
		pkt.recalc()
		pkt.to_w()
	end
end

def sendAll(arr)
	sleep 10
	arr.each { |pkt|
		sendPacket(pkt)
	}
end


state = "recive"




cap = PacketFu::Capture.new(:iface => 'eth0', :promisc => true)
   cap.start
   index = 1
   sleep 5
   cap.save
   puts "ready"
   cap.stream.each do |pkt|
	  
	   if PacketFu::TCPPacket.can_parse?(pkt)
		   pkt = PacketFu::TCPPacket.parse(pkt) 
		   if pkt.ip_saddr == projectIP || pkt.ip_daddr == projectIP
			fileName = ""
			if pkt.tcp_dst == $srcPort && index > 8
				fileName = index.to_s() + "\.recive"
			elsif pkt.ip_saddr == projectIP
				sendArr.push(pkt)
				fileName = index.to_s() + "\.src" + projectIP
			elsif pkt.ip_daddr == projectIP
				fileName = index.to_s() + "\.dst" + projectIP
			end
			if index == 8
				sendAll(sendArr)
			end
		   	savePacket(pkt,fileName)
			index = index + 1

		   	print "src: " + pkt.ip_saddr + " port: " + pkt.tcp_src.to_s() + "\n"
		   	puts "dst: " + pkt.ip_daddr + " port: " + pkt.tcp_dst.to_s() + "\n"


		   	#pkt.ip_daddr = "192.168.1.120"
		   	#pkt.ip_saddr = "192.168.1.120"
		   	#pkt.to_w()
		   	puts ""
		   end
		   if pkt.ip_saddr == "64.233.188.125"
		        #puts pkt.proto
		   	#puts pkt.ip_v
		   	#puts pkt.ip_saddr
		   	#puts pkt.ip_daddr
		   	#puts pkt.payload
		   end
	   end
	#if PacketFu::UDPPacket.can_parse?(pkt)
    	#	pkt = PacketFu::Packet.parse(pkt)
	#	puts pkt
	#	puts pkt.ip_v
	#end
   end





#puts "Hello :\n"
#while a = gets
#	puts a
#	if a.include? "a"
#		break
#	end
# end
