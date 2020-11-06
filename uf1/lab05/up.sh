#!/bin/bash
set -x

docker-compose -f docker-compose.yml up -d
sleep 1


#############################
###### dhcpserver      ######
#############################

docker cp dhcp.conf.template  dhcpserver:/etc/dnsmasq.d/dhcp.conf
docker exec dhcpserver /bin/bash -c "service dnsmasq restart;service dnsmasq status"
echo "dhcpserver: ips assignades actualment"
docker exec dhcpserver /bin/bash -c "cat /var/lib/misc/dnsmasq.leases"
sleep 1 

#############################
###### dhcpclient      ######
#############################

docker exec dhcpclient01 /bin/bash -c "dhclient eth0; dhclient -r eth0; dhclient eth0"

docker exec dhcpclient02 /bin/bash -c "dhclient eth0; dhclient -r eth0; dhclient eth0"
docker exec dhcpclient03 /bin/bash -c "dhclient eth0; dhclient -r eth0; dhclient eth0"
docker exec dhcpclient04 /bin/bash -c "dhclient eth0; dhclient -r eth0; dhclient eth0"
docker exec dhcpclient05 /bin/bash -c "dhclient eth0; dhclient -r eth0; dhclient eth0"


echo "dhcpserver: ips assignades després dels clients"
docker exec dhcpserver /bin/bash -c "cat /var/lib/misc/dnsmasq.leases"
