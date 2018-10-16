#!/bin/bash

docker-compose -f docker-compose.yml up -d
sleep 2


#############################
###### homerouter      ######
#############################
docker exec homerouter /bin/bash -c "ip route add 22.28.0.0/16 via 42.28.1.99 dev eth1"
docker exec homerouter echo 1 | tee /proc/sys/net/ipv4/ip_forward
docker exec homerouter apt install -y iptables
docker exec homerouter iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
docker exec homerouter dhcprelay iptables -A FORWARD -i eth0 -o eth1 -m state --state RELATED,ESTABLISHED -j ACCEPT
docker exec homerouter iptables -A FORWARD -i eth1 -o eth0 -j ACCEPT
sleep 1 

#############################
###### dhcpserver      ######
#############################

docker cp dhcp.conf.template  dhcpserver:/etc/dnsmasq.d/dhcp.conf
docker exec dhcpserver /bin/bash -c "ip route add 22.28.0.0/16 via 42.28.1.99 dev eth0"
docker exec dhcpserver /bin/bash -c "service dnsmasq restart;service dnsmasq status"
sleep 1 

#############################
###### dhcprelay       ######
#############################

docker exec dhcprelay  /bin/bash -c "ip route del default "
docker exec dhcprelay  /bin/bash -c "ip route add default via 42.28.1.100 dev eth0"
docker cp dhcp.conf.template.relay dhcprelay:/etc/dnsmasq.d/dhcp.conf
docker exec dhcprelay /bin/bash -c "service dnsmasq restart;service dnsmasq status"
sleep 1 

#############################
###### dhcpclientx1    ######
#############################

docker exec dhcpclientx1 /bin/bash -c "dhclient eth0; dhclient -r eth0; dhclient eth0"

#############################
###### dhcpclientx2    ######
#############################

docker exec dhcpclientx2 /bin/bash -c "dhclient eth0; dhclient -r eth0; dhclient eth0"

