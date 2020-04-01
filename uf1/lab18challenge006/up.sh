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
###### dnserver - secundari #
#############################

docker cp bindserver02/named.conf.local  dnsserver2:/etc/bind/named.conf.local
docker cp bindserver02/named.conf.options dnsserver2:/etc/bind/named.conf.options
docker cp bindserver02/zones dnsserver2:/etc/bind/zones
docker exec dnsserver2 /bin/bash -c "service bind9 restart;service bind9 status"
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
docker exec dhcpclient03 cp /etc/resolv.conf{.estetica,}

echo "====== fi de la fase de configuració ==========="
echo -e "====== inicide  la fase de validació    ===========" | tee sortida.txt
echo -e "\n\n------- comprovem els container actius ------------" | tee -a sortida.txt
docker-compose ps | tee -a sortida.txt
for i in dhcpclient01 dhcpclient02 dhcpclient03; do
        echo -e "\n#\n#\n#######-- ping from $i ------->>>>> \n#\n#"| tee -a sortida.txt;	
	for j in client01 client02 client03; do
		echo -e "\n >>>>>---- to $j -----"| tee -a sortida.txt;
		docker exec $i /bin/sh -c "ping -c 1 $j.jiznardo.org"| tee -a sortida.txt;
                done;
	echo -e "\n\n >>>>>---- to www.google.com -----"| tee -a sortida.txt;
	docker exec $i /bin/sh -c "ping -c 1 www.google.com"| tee -a sortida.txt;
	done;
echo -e "\n\n\n------- aturem el dnsserver (1)        ------------"| tee -a sortida.txt
docker stop dnsserver
for i in dhcpclient01 dhcpclient02 dhcpclient03; do
        echo -e "\n@\n@\n@@@@@@@-- ping from $i ------->>>>> \n@\n@"| tee -a sortida.txt;	
	for j in client01 client02 client03; do
		echo -e "\n >>>>>---- to $j -----"| tee -a sortida.txt;
		docker exec $i /bin/sh -c "ping -c 1 $j.jiznardo.org"| tee -a sortida.txt;
                done;
	echo -e "\n\n >>>>>---- to www.google.com -----"| tee -a sortida.txt;
	docker exec $i /bin/sh -c "ping -c 1 www.google.com"| tee -a sortida.txt;
	done;
echo "====== fi de la fase de validació    ==========="| tee -a sortida.txt
#
#

