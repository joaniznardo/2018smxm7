#!/bin/bash

## en cas de voler detall de què passa realment (màgia oculta)
## docker-compose --verbose -f docker-compose.yml up -d
docker-compose -f docker-compose.yml up -d
sleep 2


#############################
###### ftpserver       ######
#############################

docker cp proftpd.conf.lab22  ftpserver:/tmp
docker exec ftpserver cp /tmp/proftpd.conf.lab22 /etc/proftpd/proftpd.conf
docker cp tls.conf.lab22  ftpserver:/tmp
docker exec ftpserver cp /tmp/tls.conf.lab22 /etc/proftpd/tls.conf
docker exec ftpserver /bin/bash -c 'openssl req -new -newkey rsa:4096 -days 365  -nodes -x509 -keyout /tmp/proftpd.key -out /tmp/proftpd.crt -subj "/C=SP/ST=Testing/L=Barcelona/O=JDA/CN=ftp.lab22.test"'
docker exec ftpserver /bin/bash -c "service proftpd restart;service proftpd status"
sleep 1 

#############################
###### filezilla       ######
#############################
[ ! -d "./filezilla" ] && echo "Directory ./filezilla DOES NOT exists." && mkdir ./filezilla

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
docker exec ftpclient01 /bin/bash -c "ping -c 2 ftpserver"
docker exec ftpserver /bin/bash -c "nohup tcpdump -i eth0 -w /tmp/dades_rebudes.pcap port \(ftp or ftp-data\) "&
docker-compose exec ftpserver /bin/bash -c "ls -l /tmp"
##
## -- Enviem un fitxer del client al servidor
## -- Necessitem "confiar" en el servidor (-k) i no comprovem la validesa del certificat (autosignat)
## -- la transmissió és segura (xifrada) pel port 21
##
docker-compose exec ftpclient01 /bin/bash -c "echo 'hola' | tee /tmp/dades.txt"
docker-compose exec ftpclient01 /bin/bash -c "curl -T /tmp/dades.txt ftp://ubuntu:ubuntu@ftpserver -k --ftp-ssl"
docker-compose exec ftpserver /bin/bash -c "pkill -sighup tcpdump"
docker-compose exec ftpserver /bin/bash -c "ls -l /tmp"
docker-compose exec ftpserver /bin/bash -c "tcpdump -r /tmp/dades_rebudes.pcap "
echo "@@@@== fi de la fase de validació  ==========="
