

require 'packetfu'


cap = PacketFu::Capture.new(:iface => 'en0', :promisc => true)
   cap.start
   #sleep 5
   #cap.save
   cap.stream.each do |pkt|
	   if PacketFu::TCPPacket.can_parse?(pkt)
		   pkt = PacketFu::Packet.parse(pkt) 
		   puts "src: " + pkt.ip_saddr
		   puts "dst: " + pkt.ip_daddr
		   pkt.ip_daddr = "192.168.1.120"
		   pkt.ip_saddr = "192.168.1.120"
		   pkt.to_w()
		   puts ""
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
