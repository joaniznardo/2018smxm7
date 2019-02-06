#!/bin/bash

### -- 
##  ens assegurem que disposem de la darrera versió de les imatges
## --
#docker pull docker.io/joaniznardo/ubuntum7base
#docker pull docker.io/joaniznardo/ubuntum7tftp1

docker volume rm lab30_dadesserver
docker volume create lab30_dadesserver
docker run   --name helper -v lab30_dadesserver:/data alpine true
docker cp server.ini helper:/data
docker rm helper

## -- en cas de voler detall de què passa realment (màgia oculta)
## docker-compose --verbose -f docker-compose.yml up -d
docker-compose -f docker-compose.yml up -d
echo 'wait a litle bit (15 secs) while we are working...'
sleep 15

## yes - we recycle!! ;)
##export CONFIG_TFTPD=tftpd-hpa.lab24
##export DIR_TFTP=/var/lib/tftpboot/

#############################
###### mailserver      ######
#############################
### -- 
##  -- etapa 1 - crear el primer domini, un compte del domini i fer-lo administratiu
### -- 
docker-compose exec mailserver poste domain:create elmeuprimerdomini.org
docker-compose exec mailserver poste email:create admin@elmeuprimerdomini.org noposesaquestapassword
docker-compose exec mailserver poste email:admin admin@elmeuprimerdomini.org

### -- 
##  -- etapa 2 - ara que ja tenim compte administratiu, podem fer servir la REST API i crear comptes, dominis, establir quotes
### -- 
curl -v -k -u admin@elmeuprimerdomini.org:noposesaquestapassword -d 'name=nestorisback&email=nestor@elmeuprimerdomini.org&passwordPlaintext=peasovacances' https://10.28.1.100/admin/api/v1/boxes

curl -v -k -u admin@elmeuprimerdomini.org:noposesaquestapassword -d 'name=unaltredominiqualsevol.edu' https://10.28.1.100/admin/api/v1/domains
curl -v -k -u admin@elmeuprimerdomini.org:noposesaquestapassword -d 'name=molaaquestemail&email=mola@unaltredominiqualsevol.edu&passwordPlaintext=dominimolon' https://10.28.1.100/admin/api/v1/boxes
curl -v -k -u admin@elmeuprimerdomini.org:noposesaquestapassword -d 'name=shortintime&email=vistinovist@unaltredominiqualsevol.edu&passwordPlaintext=lavidaesbreu' https://10.28.1.100/admin/api/v1/boxes

curl -v -k -u admin@elmeuprimerdomini.org:noposesaquestapassword -X "DELETE" https://10.28.1.100/admin/api/v1/boxes/vistinovist@unaltredominiqualsevol.edu

### -- 
##  -- etapa 3 - comprovar-ho  de manera no interactiva
### -- 

curl -v -k -u admin@elmeuprimerdomini.org:noposesaquestapassword  https://10.28.1.100/admin/api/v1/domains
curl -v -k -u admin@elmeuprimerdomini.org:noposesaquestapassword  https://10.28.1.100/admin/api/v1/boxes

### -- 
##  -- etapa 4 - comprovar-ho a https://10.28.1.100/admin i https://10.28.1.100/webmail
### -- 
