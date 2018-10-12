#!/bin/bash

docker-compose -f docker-compose.yml up -d
sleep 2


#############################
###### dhcpserver      ######
#############################

docker cp isc-dhcp-server.server1 dhcpserver:/etc/default/isc-dhcp-server
docker cp dhcpd.conf.server1  dhcpserver:/etc/dhcp/dhcpd.conf
docker exec dhcpserver /bin/bash -c "service isc-dhcp-server restart;service isc-dhcp-server status"
docker exec dhcpserver /bin/bash -c "route add -net 42.28.0.0 netmask 255.255.0.0 dev eth0"
sleep 1 

#############################
###### dhcprelay       ######
#############################

#mantenim la següent per compatibilitat, però no fem servir els paràmetres del fitxer: fem servir els de docker exec dhcprelay
docker cp isc-dhcp-relay dhcprelay:/etc/default/isc-dhcp-relay
docker exec dhcprelay /bin/bash -c "/usr/sbin/dhcrelay -4 -i eth0 -i eth1 72.28.1.100"
#docker exec dhcprelay /bin/bash -c "/usr/sbin/dhcrelay"
sleep 1 

#############################
###### dhcpclient      ######
#############################

# -- alliberem la ip assignada per docker (en realitat nosaltres - és estàtica)
docker exec dhcpclientx2 /bin/bash -c "ip addr flush eth0"

# -- demanem una ip "a qui pugui escoltar" (servidor de dhcp, doncs ens hem acabat les ips amb el hack "ip-range" a docker-compose)
docker exec dhcpclientx2 /bin/bash -c "dhclient eth0"


