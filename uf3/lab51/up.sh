#!/bin/bash
##
## les't make some colourful 
yellow='\e[0;43m'
endColor='\e[0m'

# Display welcome message
echo -e "${yellow}Welcome $USER ${endColor}\n"
### -- 
##  ens assegurem que disposem de la darrera versió de les imatges
## --
#docker pull docker.io/joaniznardo/ubuntum7http


## -- en cas de voler detall de què passa realment (màgia oculta)
## docker-compose --verbose -f docker-compose.yml up -d
docker-compose -f docker-compose.yml up -d

## yes - we recycle!! ;)
##export CONFIG_TFTPD=tftpd-hpa.lab24
##export DIR_TFTP=/var/lib/tftpboot/

#############################
###### webserver       ######
#############################
### -- 
##  -- etapa 1 - 
### -- 
## 
#docker-compose exec apache bash

# - acceptar les variables d'entorn per defecte
docker-compose exec apache bash /etc/apache2/envvars
# - (re)iniciar el servei
docker-compose exec apache /usr/sbin/apache2ctl restart
# - comprovar que està en marxa
docker-compose exec apache netstat -atnp | grep :80 | wc -l


# etapes per crear una web:
### -- 
##  -- etapa 1 - preparar el servidor
### -- 

# - deshabilitar la que tenim per defecte
docker-compose exec apache /usr/sbin/a2dissite 000-default 
# (notar que no se pot no posar el conf, però el nom del fitxer l'ha de tindre obligatòriament)

## # - partir de sites-available i generar una de nova (que acabe en conf)
## docker-compose exec apache cp /etc/apache2/sites-available/00{0-default,1-website01}.conf
## docker-compose exec apache sed  -i '/DocumentRoot/s/html/website01/' /etc/apache2/sites-available/001-website01.conf


#- habilitar les noves sites
docker-compose exec apache /usr/sbin/a2ensite  serverjoan.lab42
docker-compose exec apache /usr/sbin/a2ensite  elmeuprimerllocweb.org 
docker-compose exec apache /usr/sbin/a2ensite  facebook.com
docker-compose exec apache /usr/sbin/a2ensite  apacheserver.test

#- refrescar i apuntar 
docker-compose exec apache /usr/sbin/apache2ctl restart

#- engegar squid 
docker-compose exec squid  squid3 

### -- 
##  -- etapa 2 - validar que ho hem aconseguit
### -- 


# accedint per nom
PROXY="-x 10.28.1.90:3128"
NOM_SERVER=www.serverjoan.lab42
echo -e "\n${yellow}Validació: comprovació des del client (per nom - $NOM_SERVER ) ${endColor}\n"
docker-compose exec textclient curl  $PROXY http://$NOM_SERVER

# accedint per nom
NOM_SERVER=www.apacheserver.test
echo -e "\n${yellow}Validació: comprovació des del client (per nom - $NOM_SERVER ) ${endColor}\n"
docker-compose exec textclient curl  $PROXY http://$NOM_SERVER

# accedint per nom
NOM_SERVER=www.facebook.com
echo -e "\n${yellow}Validació: comprovació des del client (per nom - $NOM_SERVER ) ${endColor}\n"
docker-compose exec textclient curl  $PROXY http://$NOM_SERVER

# accedint per nom
NOM_SERVER=www.elmeuprimerllocweb.org
echo -e "\n\n${yellow}Validació: comprovació des del client (per nom - $NOM_SERVER ) ${endColor}\n"
docker-compose exec textclient curl  $PROXY http://$NOM_SERVER

# comprovar fitxer /etc/hosts
echo -e "\n${yellow}Validació: comprovació del arxiu /etc/hosts ${endColor}\n"
docker-compose exec textclient cat /etc/hosts

# comprovar qui ha accedit - apache
echo -e "\n${yellow}Validació: qui accedeix? (/var/log/apache2/access.log) ${endColor}\n"
docker-compose exec apache cat /var/log/apache2/access.log

# comprovar qui ha accedit - proxy
echo -e "\n${yellow}Validació: qui accedeix? (/var/log/squid3/access.log) ${endColor}\n"
docker-compose exec squid cat /var/log/squid3/access.log

### -- 
##  -- etapa 3 - 
### -- 

### -- 
##  -- etapa 4 -
### -- 

### -- 
##  -- etapa 5 - 
### -- 
