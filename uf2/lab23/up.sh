#!/bin/bash

### -- 
##  ens assegurem que disposem de la darrera versió de les imatges
## --
#docker pull docker.io/joaniznardo/ubuntum7base
#docker pull docker.io/joaniznardo/ubuntum7ftp1

## -- en cas de voler detall de què passa realment (màgia oculta)
## docker-compose --verbose -f docker-compose.yml up -d
docker-compose -f docker-compose.yml up -d
sleep 2


CONFIG_PROFTPD=proftpd.conf.lab23
CONFIG_PROFTPD_VIRT_USERS=virtual_users.conf.lab23


#############################
###### ftpserver       ######
#############################

### --
##  -- preparacio del fitxer de comptes virtuals
### --
docker exec ftpserver touch /etc/proftpd/ftpd.passwd
# ens assegurem que sols el compte associat al proces proftpd es qui gestiona el fitxer
docker exec ftpserver chown proftpd: /etc/proftpd/ftpd.passwd
docker exec ftpserver chmod ug=r,o-r /etc/proftpd/ftpd.passwd

# injectem la configuració genèrica
docker cp $CONFIG_PROFTPD  ftpserver:/tmp
docker exec ftpserver cp /tmp/$CONFIG_PROFTPD  /etc/proftpd/proftpd.conf
# injectem la configuració específica: virtual users
docker cp $CONFIG_PROFTPD_VIRT_USERS ftpserver:/tmp
docker exec ftpserver cp /tmp/$CONFIG_PROFTPD_VIRT_USERS /etc/proftpd/conf.d/virtual_users.conf
# reinici del servei
docker exec ftpserver /bin/bash -c "service proftpd restart;service proftpd status"

### -- 
##  -- creacio dels comptes
### -- 
docker exec ftpserver /bin/bash -c "echo 'c0ntr@sseny@01' | ftpasswd --stdin --passwd --file=/etc/proftpd/ftpd.passwd --name=test01 --uid=15001 --gid=15001 --home=/home/proftpd/test01 --shell=/bin/false"

# no crearem grups per compartir info entre els comptes virtuals
## sudo ftpasswd --group --name=nogroup01 --file=/etc/proftpd/ftpd.group --gid=15001 --member test01

docker exec ftpserver /bin/bash -c "echo 'c0ntr@sseny@02' | ftpasswd --stdin --passwd --file=/etc/proftpd/ftpd.passwd --name=test02 --uid=15002 --gid=15002 --home=/home/proftpd/test02 --shell=/bin/false"

### --
##  -- creacio dels directoris privats
### --
docker exec ftpserver mkdir -m 700 -p /home/proftpd/test01
docker exec ftpserver chown 15001 /home/proftpd/test01
docker exec ftpserver mkdir -m 700 -p /home/proftpd/test02
docker exec ftpserver chown 15002 /home/proftpd/test02

### -- recorda que per comprovar error tenim el fitxer: /var/log/proftpd/proftpd.log 
### -- ...i per comprovar accessos el fitxer: /var/log/proftpd/xferlog

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
docker exec ftpclient01 /bin/bash -c "echo 'hola' | tee /tmp/test.txt"
docker exec ftpclient01 /bin/bash -c "curl -u test01:c0ntr@sseny@01 --upload-file /tmp/test.txt ftp://ftpserver/dades02.txt"

echo "@@@@== fi de la fase de validació  ==========="
