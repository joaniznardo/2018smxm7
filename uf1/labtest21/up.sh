#!/bin/bash

docker-compose -f docker-compose.yml up -d
sleep 2


#############################
###### dhcpserver      ######
#############################

docker cp dhcp.conf.template  dhcpserver:/etc/dnsmasq.d/dhcp.conf
# fer que el nostre server puga arribar a les xarxes que no coneix"
docker exec dhcpserver /bin/bash -c "route add -net 42.28.0.0 netmask 255.255.0.0 dev eth0"
docker exec dhcpserver /bin/bash -c "route add -net 12.28.0.0 netmask 255.255.0.0 dev eth0"
docker exec dhcpserver /bin/bash -c "service dnsmasq restart;service dnsmasq status"
sleep 1 

#############################
###### dhcprelayx2     ######
#############################

docker cp dhcp.conf.template.relayx2 dhcprelayx2:/etc/dnsmasq.d/dhcp.conf
docker exec dhcprelayx2 /bin/bash -c "service dnsmasq restart;service dnsmasq status"
sleep 1 

#############################
###### dhcprelayx3     ######
#############################

docker cp dhcp.conf.template.relayx3 dhcprelayx3:/etc/dnsmasq.d/dhcp.conf
docker exec dhcprelayx3 /bin/bash -c "service dnsmasq restart;service dnsmasq status"
sleep 1 

#############################
## renovació de la ip del client2 X1
#############################

# -- alliberem la ip assignada per docker (en realitat nosaltres - és estàtica)
docker exec dhcpclient2_x1 /bin/bash -c "ip addr flush eth0"

# -- demanem una ip "a qui pugui escoltar" (servidor de dhcp, doncs ens hem acabat les ips amb el hack "ip-range" a docker-compose)
docker exec dhcpclient2_x1 /bin/bash -c "dhclient eth0" &

#############################
## renovació de la ip del client2 X2
#############################

# -- alliberem la ip assignada per docker (en realitat nosaltres - és estàtica)
docker exec dhcpclient2_x2 /bin/bash -c "ip addr flush eth0"

# -- demanem una ip "a qui pugui escoltar" (servidor de dhcp, doncs ens hem acabat les ips amb el hack "ip-range" a docker-compose)
docker exec dhcpclient2_x2 /bin/bash -c "dhclient eth0" &

#############################
## renovació de la ip del client2 X3
#############################

# -- alliberem la ip assignada per docker (en realitat nosaltres - és estàtica)
docker exec dhcpclient2_x3 /bin/bash -c "ip addr flush eth0"

# -- demanem una ip "a qui pugui escoltar" (servidor de dhcp, doncs ens hem acabat les ips amb el hack "ip-range" a docker-compose)
docker exec dhcpclient2_x3 /bin/bash -c "dhclient eth0" &

#############################
## renovació de la ip del client  X1
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


#############################
###### resultats ---   ######
#############################
echo "======================================"
echo "client-x1: "  
docker exec dhcpclientx1 /bin/bash -c "ip a"
docker exec dhcpclientx1 /bin/bash -c "ip route"
docker exec dhcpclientx1 /bin/bash -c "hostname"
echo "======================================"
echo "client-x2: " 
docker exec dhcpclientx2 /bin/bash -c "ip a"
docker exec dhcpclientx2 /bin/bash -c "ip route"
docker exec dhcpclientx2 /bin/bash -c "hostname"
echo "======================================"
echo "client-x3: "
docker exec dhcpclientx3 /bin/bash -c "ip a"
docker exec dhcpclientx3 /bin/bash -c "ip route"
docker exec dhcpclientx3 /bin/bash -c "hostname"
echo "======================================"
echo "dhcpserver: ips assignades després dels clients"
docker exec dhcpserver /bin/bash -c "cat /var/lib/misc/dnsmasq.leases"

