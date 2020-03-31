#!/bin/bash

## en cas de voler detall de què passa realment (màgia oculta)
## docker-compose --verbose -f docker-compose.yml up -d
docker-compose -f docker-compose.yml up -d
sleep 2


#############################
###### dhcpserver      ######
#############################

docker cp 000_dns_resolver.conf dnsresolver:/etc/dnsmasq.d/dhcp.conf
docker exec dnsresolver /bin/bash -c "service dnsmasq restart;service dnsmasq status"
sleep 1 

#############################
###### dhcpserver      ######
#############################

docker cp bindserver01/named.conf.local  dnsserver:/etc/bind/named.conf.local
docker cp bindserver01/named.conf.options dnsserver:/etc/bind/named.conf.options
docker cp bindserver01/zones dnsserver:/etc/bind/zones
docker exec dnsserver /bin/bash -c "service bind9 restart;service bind9 status"
sleep 1 

#############################
###### dhcpclient      ######
#############################


## com de costum, la manera correcta de passar fitxers entre màquina física i contenidor és fer-ho en dos passes:
## 1) copiar (docker cp) el fitxer a un fitxer INEXISTENT del container
## 2) copiar (des de dins del container: docker exec container-name cp) el fitxer que hem copiat abans a la seua posició

#### com que el servidor de dhcp no actua hem de configurar "manualment" el client de dns.
### -- docker cp resolv.conf dhcpclient01:/etc/resolv.conf.estatica
### -- docker exec dhcpclient01 cp /etc/resolv.conf{.estatica,}

docker cp resolv.conf dhcpclient02:/etc/resolv.conf.estatica
docker exec dhcpclient02 cp /etc/resolv.conf{.estatica,}

### -- docker cp resolv.conf dhcpclient03:/etc/resolv.conf.estatica
### -- docker exec dhcpclient03 cp /etc/resolv.conf{.estatica,}

echo "====== fi de la fase de configuració ==========="
docker-compose ps
echo " -- comprovacions des del client 01 ---"
docker exec dhcpclient01 /bin/sh -c "ping -c 1 dns1.jiznardo.org"
docker exec dhcpclient01 /bin/sh -c "ping -c 1 client03.jiznardo.org"
docker exec dhcpclient01 /bin/sh -c "ping -c 1 client02.jiznardo.org"
echo " -- dig directe des del client amb el servidor .1.100 "
docker exec dhcpclient01 /bin/sh -c "dig @72.28.1.100 NS jiznardo.org"
docker exec dhcpclient01 /bin/sh -c "dig @72.28.1.100  client01.jiznardo.org"
echo " -- comprovacions des del client 02 ---"
docker exec dhcpclient02 /bin/sh -c "ping -c 1 dns1.jiznardo.org"
docker exec dhcpclient02 /bin/sh -c "ping -c 1 client03.jiznardo.org"
docker exec dhcpclient02 /bin/sh -c "ping -c 1 client01.jiznardo.org"
echo " -- dig directe des del client amb el servidor .1.100 "
docker exec dhcpclient02 /bin/sh -c "dig @72.28.1.100 NS jiznardo.org"
docker exec dhcpclient02 /bin/sh -c "dig @72.28.1.100  client01.jiznardo.org"
echo " -- comprovacions des del client 03 ---"
docker exec dhcpclient03 /bin/sh -c "ping -c 1 dns1.jiznardo.org"
docker exec dhcpclient03 /bin/sh -c "ping -c 1 client01.jiznardo.org"
docker exec dhcpclient03 /bin/sh -c "ping -c 1 client02.jiznardo.org"
echo " -- dig directe des del client amb el servidor .1.100 "
docker exec dhcpclient03 /bin/sh -c "dig @72.28.1.100 NS jiznardo.org"
docker exec dhcpclient03 /bin/sh -c "dig @72.28.1.100  client01.jiznardo.org"

echo " -- resolv client1 --"
docker exec dhcpclient01 /bin/sh -c "cat /etc/resolv.conf"
echo " -- resolv client2 --"
docker exec dhcpclient02 /bin/sh -c "cat /etc/resolv.conf"
echo " -- resolv client3 --"
docker exec dhcpclient03 /bin/sh -c "cat /etc/resolv.conf"
echo " -- ara fem ping des de client3 (no preparat: no resolv.conf modificat ni dns indicat al docker-compose"
docker exec dhcpclient03 /bin/sh -c "ping -c 2 dns1.jiznardo.org"
docker exec dhcpclient03 /bin/sh -c "ping -c 2 client01.jiznardo.org"
docker exec dhcpclient03 /bin/sh -c "ping -c 2 client02.jiznardo.org"

echo "====== fi de la fase de validació    ==========="
#
#

