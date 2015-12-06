

require 'packetfu'



projectIP = "140.113.194.85"
destIP = "140.113.194.85"
destPort = "49175"

def savePacket(pkt,fileName) 
	pkt.to_f("./" + fileName +".pcap")
end

def sendPacket(pkt)

end



cap = PacketFu::Capture.new(:iface => 'en0', :promisc => true)
   cap.start
   index = 1
   #sleep 5
   #cap.save
   cap.stream.each do |pkt|
	   if PacketFu::TCPPacket.can_parse?(pkt)
		   pkt = PacketFu::Packet.parse(pkt) 
		   break
		   if pkt.ip_saddr == projectIP or pkt.ip_daddr == projectIP
			fileName = ""
			if pkt.ip_saddr == porjectIP
				fileName = index + ".src" + projectIP
			else if pkt.ip_daddr == projectIP
				fileName = index+ ".dst" + projectIP
			end
			index = index + 1
		   	savePacket(pkt,"a")

		   	puts "src: " + pkt.ip_saddr
		   	puts "dst: " + pkt.ip_daddr
		   	pkt.ip_daddr = "192.168.1.120"
		   	pkt.ip_saddr = "192.168.1.120"
		   	pkt.to_w()
		   	puts ""
		   end
		   if pkt.ip_saddr == "64.233.188.125"
		        #puts pkt.proto
		   	#puts pkt.ip_v
		   	#puts pkt.ip_saddr
		   	puts pkt.ip_daddr
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
#end
