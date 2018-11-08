#!/bin/bash

## en cas de voler detall de què passa realment (màgia oculta)
## docker-compose --verbose -f docker-compose.yml up -d
docker-compose -f docker-compose.yml up -d
sleep 2


#############################
###### dhcpserver01    ######
#############################

docker cp 000_dns_01.conf  dnsserver01:/etc/dnsmasq.d/000_dns_01.conf
docker exec dnsserver01 /bin/bash -c "service dnsmasq restart;service dnsmasq status"
sleep 1 

#############################
###### dhcpserver02    ######
#############################

docker cp 000_dns_02.conf  dnsserver02:/etc/dnsmasq.d/000_dns_02.conf
docker exec dnsserver02 /bin/bash -c "service dnsmasq restart;service dnsmasq status"
sleep 1 

#############################
###### dhcpclient      ######
#############################


## com de costum, la manera correcta de passar fitxers entre màquina física i contenidor és fer-ho en dos passes:
## 1) copiar (docker cp) el fitxer a un fitxer INEXISTENT del container
## 2) copiar (des de dins del container: docker exec container-name cp) el fitxer que hem copiat abans a la seua posició

#### com que el servidor de dhcp no actua hem de configurar "manualment" el client de dns.
docker cp resolv.conf.domini01 dhcpclient01:/etc/resolv.conf.estatica
docker exec dhcpclient01 cp /etc/resolv.conf{.estatica,}

docker cp resolv.conf.domini01 dhcpclient02:/etc/resolv.conf.estatica
docker exec dhcpclient02 cp /etc/resolv.conf{.estatica,}

docker cp resolv.conf.domini02 dhcpclient03:/etc/resolv.conf.estatica
docker exec dhcpclient03 cp /etc/resolv.conf{.estatica,}

docker cp resolv.conf.domini02 dhcpclient04:/etc/resolv.conf.estatica
docker exec dhcpclient04 cp /etc/resolv.conf{.estatica,}

echo "====== fi de la fase de configuració ==========="
echo "====== inici de la fase de proves ==========="
docker-compose ps
echo "====== pings client 01            ==========="
docker exec dhcpclient01 /bin/sh -c "ping -c 2 client01"
docker exec dhcpclient01 /bin/sh -c "ping -c 2 client02"
docker exec dhcpclient01 /bin/sh -c "ping -c 2 client03"
docker exec dhcpclient01 /bin/sh -c "ping -c 2 client03.lab15b"
docker exec dhcpclient01 /bin/sh -c "ping -c 2 client04.lab15b"
echo "====== pings client 03            ==========="
docker exec dhcpclient03 /bin/sh -c "ping -c 2 client03"
docker exec dhcpclient03 /bin/sh -c "ping -c 2 client04"
docker exec dhcpclient03 /bin/sh -c "ping -c 2 client01"
docker exec dhcpclient03 /bin/sh -c "ping -c 2 client01.lab15a"
docker exec dhcpclient03 /bin/sh -c "ping -c 2 client02.lab15a"
echo "====== dig: consulta interactiva del client02 als 2 servidors ============"
docker exec dhcpclient01 /bin/sh -c "dig @72.28.1.100 client02.lab15a"
docker exec dhcpclient01 /bin/sh -c "dig @72.28.1.99  client02.lab15a"

echo "====== fi de la fase de proves ==========="
