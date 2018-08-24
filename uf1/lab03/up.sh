#!/bin/bash

docker-compose -f docker-compose.yml up -d
sleep 10


#############################
###### dhcpserver01    ######
#############################

docker cp dhcp.conf.template  dhcpserver01:/etc/dnsmasq.d/dhcp.conf
docker exec dhcpserver01 /bin/bash -c "service dnsmasq restart;service dnsmasq status"
sleep 2 

#############################
###### dhcpserver02    ######
#############################

docker cp dhcp.conf.template2  dhcpserver02:/etc/dnsmasq.d/dhcp.conf
docker exec dhcpserver02 /bin/bash -c "service dnsmasq restart;service dnsmasq status"
sleep 2 

#############################
###### dhcpclient      ######
#############################

docker exec dhcpclient /bin/bash -c "dhclient eth0; dhclient -r eth0; dhclient eth0"

