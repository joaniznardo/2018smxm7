#!/bin/bash

docker-compose -f docker-compose.yml up -d
sleep 10


#############################
###### dhcpserver      ######
#############################


docker cp isc-dhcp-server.server1 dhcpserver:/etc/default/isc-dhcp-server
docker cp dhcpd.conf.server1  dhcpserver:/etc/dhcp/dhcpd.conf
docker exec dhcpserver /bin/bash -c "service isc-dhcp-server restart;service isc-dhcp-server status"
sleep 2 

#############################
###### dhcpclient1_x1  ######
#############################

docker exec dhcpclient1_x1 /bin/bash -c "dhclient eth0; dhclient -r eth0; dhclient eth0"

#############################
###### dhcpclient2_x1  ######
#############################

docker exec dhcpclient2_x1 /bin/bash -c "dhclient eth0; dhclient -r eth0; dhclient eth0"

#############################
###### dhcpclient1_x2  ######
#############################

docker exec dhcpclient1_x2 /bin/bash -c "dhclient eth0; dhclient -r eth0; dhclient eth0"

#############################
###### dhcpclient2_x2  ######
#############################

docker exec dhcpclient2_x2 /bin/bash -c "dhclient eth0; dhclient -r eth0; dhclient eth0"

