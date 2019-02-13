#!/bin/bash

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

# - deshabilitar la que tenim per defecte
docker-compose exec apache /usr/sbin/a2dissite 000-default 
# (notar que no se posa el conf)

# - partir de sites-available i generar una de nova (que acabe en conf)
docker-compose exec apache cp /etc/apache2/sites-available/00{0-default,1-website01}.conf
docker-compose exec apache sed  -i '/DocumentRoot/s/html/website01/' /etc/apache2/sites-available/001-website01.conf

#- crear el directori (per exemple WEBSITE01) que s'indica al nou fitxer del lloc (seu) web
docker-compose exec apache mkdir -p /var/www/website01

#- habilitar la nova site
docker-compose exec apache /usr/sbin/a2ensite  001-website01

#- refrescar i apuntar 
docker-compose exec apache /usr/sbin/apache2ctl restart

### -- 
##  -- etapa 2 - 
### -- 

### -- 
##  -- etapa 3 - 
### -- 

### -- 
##  -- etapa 4 -
### -- 

### -- 
##  -- etapa 5 - 
### -- 
