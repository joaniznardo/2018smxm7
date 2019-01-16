#!/bin/bash

### -- 
##  ens assegurem que disposem de la darrera versió de les imatges
## --
#docker pull docker.io/joaniznardo/ubuntum7base
#docker pull docker.io/joaniznardo/ubuntum7tftp1

## -- en cas de voler detall de què passa realment (màgia oculta)
## docker-compose --verbose -f docker-compose.yml up -d
docker-compose -f docker-compose.yml up -d
sleep 2


export CONFIG_TFTPD=tftpd-hpa.lab24
export DIR_TFTP=/var/lib/tftpboot/

#############################
###### tftpserver      ######
#############################
### -- 
##  -- etapa 1 - configurar el servei de TFTP
### -- 
# injectem la configuració per permetre l'escriptura al server
docker cp $CONFIG_TFTPD tftpserver:/tmp
docker exec tftpserver cp /tmp/$CONFIG_TFTPD  /etc/default/tftpd-hpa
### -- 
##  -- etapa 2 - reiniciar el servei de TFTP
### -- 
docker exec tftpserver /bin/bash -c "service tftpd-hpa restart;service tftpd-hpa status"

### -- 
##  -- etapa 3 - creacio dels directoris
### -- 
#docker exec tftpserver /bin/bash -c "cd /var/lib/tftpboot && mktemp -d XXXXXXXXXX --suffix=-incoming && chown tftp:tftp $(ls -d *incoming) && chmod 777 $(ls -d *incoming)"
docker exec tftpserver /bin/bash -c "cd /var/lib/tftpboot && mktemp -d XXXXXXXXXX --suffix=-incoming "
export DIR_INT=`docker exec tftpserver /bin/bash -c "cd /var/lib/tftpboot && ls -d *inc*"`

## echo "DIR_INT te el valor $DIR_INT"
##echo "DIR_INT=$DIR_INT" | tee env_vars.file

##docker exec tftpserver --env-file=env_cars.file /bin/bash -c "chown tftp:tftp $DIR_INT"
##docker exec tftpserver -eDIR_INT=$DIR_INT2 /bin/bash -c "chown tftp:tftp $DIR_INT"

### -- 
##  -- etapa 4 - assignació de permissos correctes i canvi de propietari
### -- 
docker exec tftpserver  /bin/bash -c "chown tftp:tftp $DIR_TFTP$DIR_INT"
docker exec tftpserver  /bin/bash -c "chmod 777 $DIR_TFTP$DIR_INT"
docker exec tftpserver /bin/bash -c "cd /var/lib/tftpboot && mktemp -d XXXXXXXXXX --suffix=-outgoing"
export DIR_OUT=`docker exec tftpserver /bin/bash -c "cd /var/lib/tftpboot && ls -d *out*"`
docker exec tftpserver  /bin/bash -c "chmod 755 $DIR_TFTP$DIR_OUT"
docker exec tftpserver  /bin/bash -c "echo 'greetings from server' | tee $DIR_TFTP$DIR_OUT/file_in_server.txt"
#docker exec tftpserver /bin/bash -c "cd /var/lib/tftpboot && chmod 755 `mktemp -d XXXXXXXXXX --suffix=-outgoing`"



### -- recorda que: a tftp no tenim log específic; un tcpdump pot vindre molt bé per detectar errors: tcpdump -i eth0 port 69 -v

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
docker exec tftpclient01 /bin/bash -c "ping -c 2 tftpserver"
docker exec tftpclient01 /bin/bash -c "echo 'greetings from client!!' | tee /tmp/test.txt"

# necessitem saber qui és el directori destí
## DIR_INT=`docker exec tftpserver /bin/bash -c "cd /var/lib/tftpboot && ls -d *inc*"`
docker exec tftpclient01 /bin/bash -c "curl --upload-file /tmp/test.txt tftp://tftpserver/$DIR_INT/dades02.txt"
docker exec tftpclient01 /bin/bash -c "curl -o /tmp/received_from_server_file.txt tftp://tftpserver/$DIR_OUT/file_in_server.txt" 


echo "@@@@== fi de la fase de validació  ==========="
