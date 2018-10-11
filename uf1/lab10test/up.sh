#!/bin/bash

docker-compose -f docker-compose.yml up -d
sleep 22


#############################
###### dhcpserver      ######
#############################

docker cp dhcp.conf.template  dhcpserver:/etc/??????????
docker exec dhcpserver /bin/bash -c "route add -net 42.28.0.0 netmask 255.255.0.0 dev eth0"
docker exec dhcpserver /bin/bash -c "?????????????????"
sleep 1 

#############################
###### dhcprelay       ######
#############################

docker cp dhcp.conf.template.relay dhcprelay:/etc/?????????????
docker exec dhcprelay /bin/bash -c "???????????????"
sleep 1 

#############################
###### dhcpclient      ######
#############################

docker exec dhcpclientx2 /bin/bash -c "dhclient eth0; dhclient -r eth0; dhclient eth0"

