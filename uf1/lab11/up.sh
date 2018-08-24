#!/bin/bash

docker-compose -f docker-compose.yml up -d
sleep 4


#############################
###### dhcpserver      ######
#############################

docker cp dhcp.conf.template  dhcpdnsserver:/etc/dnsmasq.d/dhcp.conf
docker exec dhcpdnsserver /bin/bash -c "service dnsmasq restart;service dnsmasq status"
sleep 2 

#############################
###### dhcpclient      ######
#############################

docker exec dhcpclient /bin/bash -c "dhclient eth0; dhclient -r eth0; dhclient eth0"

