#!/bin/bash

## en cas de voler detall de què passa realment (màgia oculta)
## docker-compose --verbose -f docker-compose.yml up -d
docker-compose -f docker-compose.yml up -d
sleep 2


#############################
###### ftpserver       ######
#############################

#docker cp dhcp.conf.template  dhcpdnsserver:/etc/dnsmasq.d/dhcp.conf
docker exec ftpserver /bin/bash -c "service proftpd restart;service proftpd status"
sleep 1 

#############################
###### ftpclient       ######
#############################


## com de costum, la manera correcta de passar fitxers entre màquina física i contenidor és fer-ho en dos passes:
## 1) copiar (docker cp) el fitxer a un fitxer INEXISTENT del container
## 2) copiar (des de dins del container: docker exec container-name cp) el fitxer que hem copiat abans a la seua posició

#### com que el servidor de dhcp no actua hem de configurar "manualment" el client de dns.
#docker cp resolv.conf dhcpclient01:/etc/resolv.conf.estatica
#docker exec dhcpclient01 cp /etc/resolv.conf{.estatica,}


echo "====== fi de la fase de configuració ==========="
echo "@@@@== inici de la fae de validació  ==========="
docker-compose ps
docker exec ftpclient01 /bin/sh -c "ping -c 2 ftpserver"
echo "@@@@== fi de la fase de validació  ==========="
