#!/bin/bash -x
set -x
#set -v
docker-compose -f docker-compose.yml up -d
sleep 5 


#############################
###### dhcpserver      ######
#############################


docker cp isc-dhcp-server.server1 dhcpserver:/etc/default/isc-dhcp-server
docker cp dhcpd.conf.server1  dhcpserver:/etc/dhcp/dhcpd.conf
docker exec dhcpserver /bin/bash -c "service isc-dhcp-server restart;service isc-dhcp-server status"
sleep 2 

# posem a escoltar el server
(docker exec -t dhcpserver tcpdump -v -i eth0 -n port bootps or bootpc | tee dhcpserver.pcap) &

#############################
###### dhcpclient      ######
#############################
echo -e "\nComprovem la ip abans de demanarla"
docker exec dhcpclient1 /bin/bash -c "ip a"
#docker exec dhcpclient1 ip a del 72.28.1.101/32 dev eth0
#docker exec dhcpclient1 /bin/bash -c "ip a"
#docker exec dhcpclient1 /bin/bash -c "dhclient eth0"
#docker exec dhcpclient1 /bin/bash -c "ip a"

# necessari per no tindre una ip fixa i un alias (ip dinàmica)  
docker exec dhcpclient1 /bin/bash -c "dhclient eth0; dhclient -r eth0; dhclient eth0"
echo -e "\nComprovem la ip DESPRES de demanarla"
docker exec dhcpclient1 /bin/bash -c "ip a"
# si no alliberem la ip aleshores afegeix un alias
#docker exec dhcpclient1 /bin/bash -c "dhclient -r eth0; dhclient eth0"

echo -e "\nalliberem el server del tcpdump"
docker exec -it dhcpserver pkill tcpdump
