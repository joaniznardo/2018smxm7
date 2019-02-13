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
echo 'wait a litle bit (30 secs) while we are working...'
sleep 30

## yes - we recycle!! ;)
##export CONFIG_TFTPD=tftpd-hpa.lab24
##export DIR_TFTP=/var/lib/tftpboot/

#############################
###### mailserver      ######
#############################
### -- 
##  -- etapa 1 - crear el primer domini, un compte del domini i fer-lo administratiu
### -- 
## creació de domini - API: poste
docker-compose exec mailserver poste domain:create elmeuprimerdomini.org

## creació de email - API: poste
docker-compose exec mailserver poste email:create admin@elmeuprimerdomini.org noposesaquestapassword

## creació de compte administratiu - API: poste
docker-compose exec mailserver poste email:admin admin@elmeuprimerdomini.org

## creació de email - API: poste
docker-compose exec mailserver poste email:create compteambquota@elmeuprimerdomini.org passwordinsegura

## establiment de quota per nombre d' emails  - API: poste
docker-compose exec mailserver poste email:quota compteambquota@elmeuprimerdomini.org 5 0 

## establiment de quota pel tamany  de cada email  - API: poste
docker-compose exec mailserver poste email:quota compteambquota@elmeuprimerdomini.org 0 5 

## establiment de quota doble (nombre i tamany)  - API: poste
docker-compose exec mailserver poste email:quota compteambquota@elmeuprimerdomini.org 10 6 


### -- 
##  -- etapa 2 - ara que ja tenim compte administratiu, podem fer servir la REST API i crear comptes, dominis, establir quotes
### -- 

##  creació de compte - REST API
curl -v -k -u admin@elmeuprimerdomini.org:noposesaquestapassword -d 'name=nestorisback&email=nestor@elmeuprimerdomini.org&passwordPlaintext=peasovacances' https://10.28.1.100/admin/api/v1/boxes

##  creació de domini - REST API
curl -v -k -u admin@elmeuprimerdomini.org:noposesaquestapassword -d 'name=unaltredominiqualsevol.edu' https://10.28.1.100/admin/api/v1/domains

##  creació de compte - REST API
curl -v -k -u admin@elmeuprimerdomini.org:noposesaquestapassword -d 'name=molaaquestemail&email=mola@unaltredominiqualsevol.edu&passwordPlaintext=dominimolon' https://10.28.1.100/admin/api/v1/boxes

##  creació de compte - REST API
curl -v -k -u admin@elmeuprimerdomini.org:noposesaquestapassword -d 'name=shortintime&email=vistinovist@unaltredominiqualsevol.edu&passwordPlaintext=lavidaesbreu' https://10.28.1.100/admin/api/v1/boxes

## exemple de canvi de contrassenya - REST API
curl -v -k -u admin@elmeuprimerdomini.org:noposesaquestapassword -X "PATCH" -d "passwordPlaintext=flipaencarames" https://10.28.1.100/admin/api/v1/boxes/mola@unaltredominiqualsevol.edu

## exemple d'esborrat de compte - REST API
curl -v -k -u admin@elmeuprimerdomini.org:noposesaquestapassword -X "DELETE" https://10.28.1.100/admin/api/v1/boxes/vistinovist@unaltredominiqualsevol.edu


### ------------- !!!!!!
# atenció a l'enviament de valors no textuals a través de curl!
### ------------- !!!!!!
# -- establiment d'un valor booleà (true/false)
# -- des/activació d'un compte administratiu
curl -v -k -u admin@elmeuprimerdomini.org:noposesaquestapassword --header "Content-Type: application/json" -X "PATCH" --data '{"superAdmin":true}' https://10.28.1.100/admin/api/v1/boxes/compteambquota@elmeuprimerdomini.org 

# -- establiment d'un valor numèric (float: tot i que només acceptarà enters)
# -- fixem un valor enter per a la quota de disc, per volum de missatges o nombre de visatges
curl -v -k -u admin@elmeuprimerdomini.org:noposesaquestapassword --header "Content-Type: application/json" -X "PATCH" --data '{"storageLimit":20}' https://10.28.1.100/admin/api/v1/boxes/compteambquota@elmeuprimerdomini.org/quota 

## - validació
curl -v -k -u admin@elmeuprimerdomini.org:noposesaquestapassword  https://10.28.1.100/admin/api/v1/boxes/compteambquota@elmeuprimerdomini.org/quota 

# -- establiment d'un valor numèric (float: tot i que només acceptarà enters)
# -- fixem un valor enter per a la quota de disc, per volum de missatges o nombre de visatges
curl -v -k -u admin@elmeuprimerdomini.org:noposesaquestapassword --header "Content-Type: application/json" -X "PATCH" --data '{"countLimit":12}' https://10.28.1.100/admin/api/v1/boxes/compteambquota@elmeuprimerdomini.org/quota 

## - validació
curl -v -k -u admin@elmeuprimerdomini.org:noposesaquestapassword  https://10.28.1.100/admin/api/v1/boxes/compteambquota@elmeuprimerdomini.org/quota 

### -- 
### -- 
##  -- etapa 3 - comprovar-ho  de manera no interactiva
### -- 

## exemple de consulta de dominis - REST API
curl -v -k -u admin@elmeuprimerdomini.org:noposesaquestapassword  https://10.28.1.100/admin/api/v1/domains

## exemple de consulta de comptes - REST API
curl -v -k -u admin@elmeuprimerdomini.org:noposesaquestapassword  https://10.28.1.100/admin/api/v1/boxes

### -- 
##  -- etapa 4 - "traca" final: enviar un email "efforless"
### -- 
echo -e "From: <nestor@elmeuprimerdomini.org>" | tee email.txt
echo -e "To: <mola@unaltredominiqualsevol.edu>" | tee -a email.txt
echo -e "Subject: Sending from command line" | tee -a email.txt
echo -e "Date: `date -R`" | tee -a email.txt
echo -e "\nCurl is your best friend! ;)" | tee -a email.txt
curl -v -k --url smtps://10.28.1.100 --ssl-reqd --mail-from nestor@elmeuprimerdomini.org --mail-rcpt mola@unaltredominiqualsevol.edu --user nestor@elmeuprimerdomini.org:peasovacances --upload-file email.txt

## even without generating a single file - https://news.ycombinator.com/item?id=18506601
#curl -v -k --url smtps://10.28.1.100 --ssl-reqd --mail-from nestor@elmeuprimerdomini.org --mail-rcpt mola@unaltredominiqualsevol.edu --user nestor@elmeuprimerdomini.org:peasovacances --upload-file <(echo -e 'From: nestor@elmeuprimerdomini.org\nTo: mola@unaltredominiqualsevol.edu\nSubject: Curl Test\n\nHello');

### -- 
##  -- etapa 5 - comprovar-ho tot a https://10.28.1.100/admin i https://10.28.1.100/webmail
### -- 
