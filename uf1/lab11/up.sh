#!/bin/bash

docker-compose -f docker-compose.yml up -d
sleep 2


#############################
###### dhcpserver      ######
#############################

docker cp dhcp.conf.template  dhcpdnsserver:/etc/dnsmasq.d/dhcp.conf
docker exec dhcpdnsserver /bin/bash -c "service dnsmasq restart;service dnsmasq status"
sleep 1 

#############################
###### dhcpclient      ######
#############################


## com de costum, la manera correcta de passar fitxers entre màquina física i contenidor és fer-ho en dos passes:
## 1) copiar (docker cp) el fitxer a un fitxer INEXISTENT del container
## 2) copiar (des de dins del container: docker exec container-name cp) el fitxer que hem copiat abans a la seua posició

#### - comentat per inotify #### 
## docker cp resolv.conf dhcpclient:/etc/resolv.confi
## docker exec dhcpclient cp /etc/resolv.conf{i,}
docker cp resolv.conf-cirumvention dhcpclient:/tmp/resolv.conf-circumvention
docker exec -d dhcpclient sh /tmp/resolv.conf-circumvention 

docker exec dhcpclient /bin/bash -c "dhclient eth0; dhclient -r eth0; dhclient eth0"
