#!/bin/bash

docker-compose -f docker-compose.yml up -d
sleep 10


#############################
###### dhcpserver      ######
#############################

docker cp dhcp.conf.template  dhcpserver:/etc/dnsmasq.d/dhcp.conf
docker exec dhcpserver /bin/bash -c "service dnsmasq restart;service dnsmasq status"
sleep 2 

#############################
###### dhcpclient      ######
#############################

docker exec dhcpclient /bin/bash -c "dhclient eth0; dhclient -r eth0; dhclient eth0"

