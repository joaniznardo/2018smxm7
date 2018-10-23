#!/bin/bash

docker-compose -f docker-compose.yml up -d
sleep 2


#############################
###### dhcpserver      ######
#############################

#@@ docker cp dhcp.conf.template  dhcpserver:/etc/dnsmasq.d/dhcp.conf
docker cp isc-dhcp-server.server1 dhcpserver:/etc/default/isc-dhcp-server
docker cp dhcpd.conf.server1 dhcpserver:/etc/dhcp/dhcpd.conf
# fer que el nostre server puga arribar a les xarxes que no coneix"
docker exec dhcpserver /bin/bash -c "route add -net 42.28.1.0 netmask 255.255.255.0 dev eth0"
docker exec dhcpserver /bin/bash -c "route add -net 12.28.1.0 netmask 255.255.255.0 dev eth0"
#@@ docker exec dhcpserver /bin/bash -c "service dnsmasq restart;service dnsmasq status"
docker exec dhcpserver /bin/bash -c "service isc-dhcp-server restart;service isc-dhcp-server status"
sleep 1 

#############################
###### dhcprelayx2     ######
#############################

#@@ docker cp dhcp.conf.template.relayx2 dhcprelayx2:/etc/dnsmasq.d/dhcp.conf
#@@ docker exec dhcprelayx2 /bin/bash -c "service dnsmasq restart;service dnsmasq status"
#mantenim la següent per compatibilitat, però no fem servir els paràmetres del fitxer: fem servir els de docker exec dhcprelay
docker cp isc-dhcp-relayx2 dhcprelayx2:/etc/default/isc-dhcp-relay
docker exec dhcprelayx2 /bin/bash -c "/usr/sbin/dhcrelay -4 -i eth0 -i eth1 72.28.1.100"

sleep 1 

#############################
###### dhcprelayx3     ######
#############################

#@@docker cp dhcp.conf.template.relayx3 dhcprelayx3:/etc/dnsmasq.d/dhcp.conf
#@@docker exec dhcprelayx3 /bin/bash -c "service dnsmasq restart;service dnsmasq status"
#mantenim la següent per compatibilitat, però no fem servir els paràmetres del fitxer: fem servir els de docker exec dhcprelay
docker cp isc-dhcp-relayx3 dhcprelayx3:/etc/default/isc-dhcp-relay
docker exec dhcprelayx3 /bin/bash -c "/usr/sbin/dhcrelay -4 -i eth0 -i eth1 72.28.1.100"
sleep 1 

#############################
## renovació de la ip del client X1
#############################

# -- alliberem la ip assignada per docker (en realitat nosaltres - és estàtica)
docker exec dhcpclientx1 /bin/bash -c "ip addr flush eth0"

# -- demanem una ip "a qui pugui escoltar" (servidor de dhcp, doncs ens hem acabat les ips amb el hack "ip-range" a docker-compose)
docker exec dhcpclientx1 /bin/bash -c "dhclient eth0" &

#############################
## renovació de la ip del client X2
#############################

# -- alliberem la ip assignada per docker (en realitat nosaltres - és estàtica)
docker exec dhcpclientx2 /bin/bash -c "ip addr flush eth0"

# -- demanem una ip "a qui pugui escoltar" (servidor de dhcp, doncs ens hem acabat les ips amb el hack "ip-range" a docker-compose)
docker exec dhcpclientx2 /bin/bash -c "dhclient eth0" &

#############################
## renovació de la ip del client X3
#############################

# -- alliberem la ip assignada per docker (en realitat nosaltres - és estàtica)
docker exec dhcpclientx3 /bin/bash -c "ip addr flush eth0"

# -- demanem una ip "a qui pugui escoltar" (servidor de dhcp, doncs ens hem acabat les ips amb el hack "ip-range" a docker-compose)
docker exec dhcpclientx3 /bin/bash -c "dhclient eth0" &

sleep 2
#############################
###### resultats ---   ######
#############################
echo "======================================"
echo "client-x1: "  
docker exec dhcpclientx1 /bin/bash -c "ip a"
docker exec dhcpclientx1 /bin/bash -c "ip route"
docker exec dhcpclientx1 /bin/bash -c "hostname"
docker exec dhcpclientx1 /bin/bash -c "ping -c 3 www.google.com"
echo "======================================"
echo "client-x2: " 
docker exec dhcpclientx2 /bin/bash -c "ip a"
docker exec dhcpclientx2 /bin/bash -c "ip route"
docker exec dhcpclientx2 /bin/bash -c "hostname"
docker exec dhcpclientx2 /bin/bash -c "ping -c 3 www.google.com"
echo "======================================"
echo "client-x3: "
docker exec dhcpclientx3 /bin/bash -c "ip a"
docker exec dhcpclientx3 /bin/bash -c "ip route"
docker exec dhcpclientx3 /bin/bash -c "hostname"
docker exec dhcpclientx3 /bin/bash -c "ping -c 3 www.google.com"
echo "======================================"
echo "dhcpserver: ips assignades després dels clients"
docker exec dhcpserver /bin/bash -c "cat /var/lib/dhcp/dhcpd.leases"
docker cp dhcpserver:/var/lib/dhcp/dhcpd.leases dhcpd.leases-resultat

