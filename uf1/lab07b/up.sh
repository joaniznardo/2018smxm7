#!/bin/bash -x
# redundant (abaix) si fem el #!/bin/bash -x
set -x

#set -v

export SLEEP_COMPOSE=1
export SLEEP_DHCPSERVER=1
docker-compose -f docker-compose.yml up -d
sleep $SLEEP_COMPOSE


#############################
###### dhcpserver      ######
#############################


docker cp isc-dhcp-server.server1 dhcpserver:/etc/default/isc-dhcp-server
docker cp dhcpd.conf.server1  dhcpserver:/etc/dhcp/dhcpd.conf
docker exec dhcpserver /bin/bash -c "service isc-dhcp-server restart;service isc-dhcp-server status"

# posem a escoltar el server
## observant en pantalla: obtindrem en el host un fitxer (dhcpserver.pcap) com a sortida del tcpdump
## (docker exec -t dhcpserver tcpdump -v -i eth0 -n port bootps or bootpc | tee dhcpserver.pcap) &


## observant a posteriori via fitxer: obtindrem un fitxer "intern" al container que podem recuperar amb un "docker cp ..."
## >> (docker exec -t dhcpserver tcpdump --immediate-mode -w intern.pcap -v -i eth0 -n port bootps or bootpc)&
## ******************** la clau està en > --immediate-mode < doncs forcem al nucli a escriure a fitxer cada captura !! ;)
docker exec -dt dhcpserver tcpdump --immediate-mode -w intern.pcap -v -i eth0 -n port bootps or bootpc
sleep $SLEEP_DHCPSERVER

#############################
###### dhcpclient      ######
#############################
echo -e "\nComprovem la ip (abans   dhcp)"
docker exec dhcpclient1 ip a 
echo -e "\nComprovem la passarela (abans   dhcp)"
docker exec dhcpclient1 ip r 
echo -e "\nComprovem el resolver assignat (abans   dhcp)"
docker exec dhcpclient1 cat /etc/resolv.conf 
#docker exec dhcpclient1 ip a del 72.28.1.101/32 dev eth0
#docker exec dhcpclient1 /bin/bash -c "ip a"
#docker exec dhcpclient1 /bin/bash -c "dhclient eth0"
#docker exec dhcpclient1 /bin/bash -c "ip a"

### old-way - unkowing ip a flush :)
### necessari per no tindre una ip fixa i un alias (ip dinàmica)  
##docker exec dhcpclient1 /bin/bash -c "dhclient eth0; dhclient -r eth0; dhclient eth0"
##echo -e "\nComprovem la ip DESPRES de demanarla"
##docker exec dhcpclient1 /bin/bash -c "ip a"
### si no alliberem la ip aleshores afegeix un alias
###docker exec dhcpclient1 /bin/bash -c "dhclient -r eth0; dhclient eth0"

echo -e "\nAlliberem la ip estàtica"
docker exec dhcpclient1 ip a flush dev eth0
echo -e "\nComprovem la ip (despres alliberar - abans dhcp)"
docker exec dhcpclient1 ip a 

echo -e "\nHACK OF THE DAY: per permetre al server de dhcp que actualitze el fitxer resolv.conf cal que desmuntem /etc/resolv.conf"
docker exec dhcpclient1 /bin/bash -c "umount /etc/resolv.conf"

echo -e "\nDemanem ip"
docker exec dhcpclient1 /bin/bash -c "dhclient eth0;"

echo -e "\nComprovem la ip (després dhcp)"
docker exec dhcpclient1 ip a 
echo -e "\nComprovem la passarela (després dhcp)"
docker exec dhcpclient1 ip r 
echo -e "\nComprovem el resolver assignat (després dhcp)"
docker exec dhcpclient1 cat /etc/resolv.conf 

echo -e "\nalliberem el server del tcpdump"
docker exec -it dhcpserver pkill tcpdump

echo -e "\nRevisem la captura"
#docker exec -ti dhcpserver tcpdump -r dhcpserver.pcap
docker exec -ti dhcpserver tcpdump -n -v -r intern.pcap | tee extern.pcap.txt

echo -e "\nConservem l'original per si volem fer-lo servir amb wireshark" 
docker cp dhcpserver:intern.pcap extern.pcap
