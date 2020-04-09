#!/bin/bash

## en cas de voler detall de què passa realment (màgia oculta)
## docker-compose --verbose -f docker-compose.yml up -d
docker-compose -f docker-compose.yml up -d
sleep 2

#############################
###### dnserver - primari ###
#############################

docker cp bindserver01/named.conf.local  dnsserver:/etc/bind/named.conf.local
docker cp bindserver01/named.conf.options dnsserver:/etc/bind/named.conf.options
docker cp bindserver01/zones dnsserver:/etc/bind/zones
docker exec dnsserver /bin/bash -c "service bind9 restart;service bind9 status"
sleep 1 

#############################
###### dnserver - secundari 1
#############################

docker cp bindserver02/named.conf.local  dnsserver2:/etc/bind/named.conf.local
docker cp bindserver02/named.conf.options dnsserver2:/etc/bind/named.conf.options
docker cp bindserver02/zones dnsserver2:/etc/bind/zones
docker exec dnsserver2 /bin/bash -c "service bind9 restart;service bind9 status"
sleep 1 

#############################
###### dnserver - secundari 2
#############################

docker cp bindserver03/named.conf.local  dnsserver3:/etc/bind/named.conf.local
docker cp bindserver03/named.conf.options dnsserver3:/etc/bind/named.conf.options
docker cp bindserver03/zones dnsserver3:/etc/bind/zones
docker exec dnsserver3 /bin/bash -c "service bind9 restart;service bind9 status"
sleep 1 

#############################
###### dhcpclient      ######
#############################


## com de costum, la manera correcta de passar fitxers entre màquina física i contenidor és fer-ho en dos passes:
## 1) copiar (docker cp) el fitxer a un fitxer INEXISTENT del container
## 2) copiar (des de dins del container: docker exec container-name cp) el fitxer que hem copiat abans a la seua posició

#### com que el servidor de dhcp no actua hem de configurar "manualment" el client de dns.
docker cp resolv.conf dhcpclient01:/etc/resolv.conf.estatica
docker exec dhcpclient01 cp /etc/resolv.conf{.estatica,}

docker cp resolv.conf dhcpclient02:/etc/resolv.conf.estatica
docker exec dhcpclient02 cp /etc/resolv.conf{.estatica,}

docker cp resolv.conf dhcpclient03:/etc/resolv.conf.estatica
docker exec dhcpclient03 cp /etc/resolv.conf{.estatica,}

docker cp resolv.conf dhcpclient04:/etc/resolv.conf.estatica
docker exec dhcpclient04 cp /etc/resolv.conf{.estatica,}

docker cp resolv.conf dhcpclient05:/etc/resolv.conf.estatica
docker exec dhcpclient05 cp /etc/resolv.conf{.estatica,}

echo "====== fi de la fase de configuració ==========="
echo "====== inicide  la fase de validació    ==========="
echo "------- comprovem els container actius ------------"
docker-compose ps
echo "------- ping client01 > dns1           ------------"
docker exec dhcpclient01 /bin/sh -c "ping -c 2 dns1.jiznardo.org"
echo "------- ping client01 > client01       ------------"
docker exec dhcpclient01 /bin/sh -c "ping -c 2 client01.jiznardo.org"
echo "------- ping client01 > client02       ------------"
docker exec dhcpclient01 /bin/sh -c "ping -c 2 client02.jiznardo.org"
echo "------- ping client01 > client04       ------------"
docker exec dhcpclient01 /bin/sh -c "ping -c 2 client04.j20200331iznardo.edu"
docker exec dhcpclient01 /bin/sh -c "dig @72.28.1.100 NS jiznardo.org"
docker exec dhcpclient01 /bin/sh -c "dig @72.28.1.100  client01.jiznardo.org"
docker exec dhcpclient01 /bin/sh -c "dig @72.28.1.100 -x 72.28.1.102"
docker exec dhcpclient01 /bin/sh -c "dig @72.28.1.100  client04.j20200331iznardo.edu"
docker exec dhcpclient01 /bin/sh -c "dig @72.28.1.100 -x 72.28.1.102"
docker exec dhcpclient01 /bin/sh -c "dig @72.28.1.100 -x 72.28.1.105"
echo "------- aturem el dnsserver (1)        ------------"
docker stop dnsserver2
echo "------- ...després d'aturar server1 - comprovem els container actius ------------"
docker-compose ps
echo "------- ...després d'aturar server1 - ping client01 > client01       ------------"
docker exec dhcpclient01 /bin/sh -c "ping -c 2 client01.jiznardo.org"
echo "------- ...després d'aturar server1 - ping client01 > client02       ------------"
docker exec dhcpclient01 /bin/sh -c "ping -c 2 client02.jiznardo.org"
echo "====== fi de la fase de validació    ==========="
#
#

