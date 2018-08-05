#!/bin/bash

docker-compose up -d -f docker-compose.yml
sleep 10


#############################
###### dhcpserver      ######
#############################

docker exec dhcpserver cp  /dhcp.conf.template  dhcpserver:/etc/dnsmasq.d/dhcp.conf
docker exec dhcpserver /bin/bash -c "service dnsmasq restart;service dnsmasq status"

#############################
###### dhcpclient      ######
#############################

docker exec dhcpclient /bin/bash -c "dhclient eth0; dhclient -r eth0; dhclient eth0"

