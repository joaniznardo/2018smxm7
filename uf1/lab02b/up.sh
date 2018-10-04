#!/bin/bash

docker-compose -f docker-compose.yml up -d
sleep 2


#############################
###### dhcpserver      ######
#############################

docker cp dhcp.conf.template  dhcpserver:/etc/dnsmasq.d/dhcp.conf
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
###### dhcpclientx1    ######
#############################

docker exec dhcpclientx1 /bin/bash -c "dhclient eth0; dhclient -r eth0; dhclient eth0"

#############################
###### dhcpclientx2    ######
#############################

docker exec dhcpclientx2 /bin/bash -c "dhclient eth0; dhclient -r eth0; dhclient eth0"

#############################
###### dhcpclientx3    ######
#############################

docker exec dhcpclientx3 /bin/bash -c "dhclient eth0; dhclient -r eth0; dhclient eth0"


#############################
###### resultats ---   ######
#############################
echo "client-x1: "  
docker exec dhcpclientx1 /bin/bash -c "ip a"
docker exec dhcpclientx1 /bin/bash -c "ip route"
echo "client-x2: " 
docker exec dhcpclientx2 /bin/bash -c "ip a"
docker exec dhcpclientx2 /bin/bash -c "ip route"
echo "client-x3: "
docker exec dhcpclientx3 /bin/bash -c "ip a"
docker exec dhcpclientx3 /bin/bash -c "ip route"
