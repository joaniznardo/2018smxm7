#!/bin/bash

## en cas de voler detall de què passa realment (màgia oculta)
## docker-compose --verbose -f docker-compose.yml up -d
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
### just testing ## docker exec dhcpclient /bin/bash -c "resolvconf --updates-are-enabled; echo $?; resolvconf --enable-updates; echo $?; resolvconf --updates-are-enabled; echo $?"
docker cp resolv.conf-cirumvention dhcpclient:/tmp/resolv.conf-circumvention
docker exec -d dhcpclient sh /tmp/resolv.conf-circumvention 

## per resoldre els noms a partir del dnsserver i no del /etc/hosts
docker exec dhcpclient /bin/bash -c "sed -i -e '/hosts/s/files dns/dns files/g' /etc/nsswitch.conf"

docker exec dhcpclient /bin/bash -c "dhclient eth0; dhclient -r eth0; dhclient eth0"
