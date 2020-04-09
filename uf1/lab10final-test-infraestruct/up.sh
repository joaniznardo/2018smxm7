#!/bin/bash -x
# redundant (abaix) si fem el #!/bin/bash -x
set -x

#set -v

export SLEEP_COMPOSE=1
export SLEEP_DHCPSERVER=1
docker-compose -f docker-compose.yml up -d --scale dhcpclient3=5
sleep $SLEEP_COMPOSE

#############################
###### dnsserver       ######
#############################

docker cp bindserver01/rndc.key  dnsserver:/etc/bind/rndc.key.tmp
docker exec dnsserver cp /etc/bind/rndc.key{.tmp,}
docker cp bindserver01/named.conf  dnsserver:/etc/bind/named.conf
docker cp bindserver01/named.conf.local  dnsserver:/etc/bind/named.conf.local
docker cp bindserver01/named.conf.log    dnsserver:/etc/bind/named.conf.log  
docker cp bindserver01/named.conf.options dnsserver:/etc/bind/named.conf.options
#docker cp bindserver01/zones dnsserver:/etc/bind/zones
docker cp bindserver01/zones/db.jiznardo.org dnsserver:/var/lib/bind
docker cp bindserver01/zones/db.1.28.72 dnsserver:/var/lib/bind
docker exec dnsserver /bin/bash -c "service bind9 restart;service bind9 status"
sleep $SLEEP_DHCPSERVER

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
docker exec -dt dhcpserver tcpdump --immediate-mode -w intern.pcap -v -i eth0 -n port bootps or bootpc or domain
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

#docker exec dhcpclient2 ip a flush dev eth0
#docker exec dhcpclient2 /bin/bash -c "umount /etc/resolv.conf"
#docker exec dhcpclient2 /bin/bash -c "dhclient eth0;"

#docker exec dhcpclient3 ip a flush dev eth0
#docker exec dhcpclient3 /bin/bash -c "umount /etc/resolv.conf"
#docker exec dhcpclient3 /bin/bash -c "dhclient eth0;"

echo -e "\nRevisem la captura"
#docker exec -ti dhcpserver tcpdump -r dhcpserver.pcap
docker exec -ti dhcpserver tcpdump -n -v -r intern.pcap | tee extern.pcap.txt

echo -e "\nConservem l'original per si volem fer-lo servir amb wireshark" 
docker cp dhcpserver:intern.pcap extern.pcap

echo -e "\nConservem el LOG del dnsserver per determinar què passa al nostre servidor"
docker cp dnsserver:/var/lib/bind/bind.log bind.log

echo -e "\nConservem el registre dels préstecs de les ips del servidor"
docker cp dhcpserver:/var/lib/dhcp/dhcpd.leases dhcp.leases

echo -e "\nConservem el registre dels préstecs al propi client"
docker cp dhcpclient1:/var/lib/dhcp/dhclient.leases dhcclient.leases.client1
