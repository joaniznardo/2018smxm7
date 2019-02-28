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

#
# -- preparem el sistema operatiu per a que cada compte que se cree tingui el directori "public_html" (pot ser el que vulguis)
# -- (nota: en entorns gràfics caldrà modificar el fitxer /etc/xdg/user-dirs.defaults
#
docker-compose exec apache mkdir -m 755 /etc/skel/public_html

##
## -- creació dels comptes
## 
LLISTA_COMPTES=("jordi" "david" "anna" "marta")
for i in {0..3}; do 
  docker-compose exec apache useradd -m ${LLISTA_COMPTES[i]};
done

##
## -- generem un index a cada compte :)
##
for i in {0..3}; do 
docker cp www/index.html webserver:/home/${LLISTA_COMPTES[i]}/public_html/index.html;
docker-compose exec  apache sed -i '/name/s//'${LLISTA_COMPTES[i]}'/' /home/${LLISTA_COMPTES[i]}/public_html/index.html;
done

# --
# -- habilitar les webs per usuari del sistema: disposem d'un mòdul que ho fa i duu associat un fitxer de configuració 
# -- 
docker-compose exec apache /usr/sbin/a2enmod userdir 

# --
# -- habilitar les noves sites (no cal en aquest cas; 
# -- podrien conviure les webs personals amb altres globals (de clients, p. e.)
# --
#docker-compose exec apache /usr/sbin/a2ensite  001-website01
#docker-compose exec apache /usr/sbin/a2ensite  002-website02
#docker-compose exec apache /usr/sbin/a2ensite  003-website03
#docker-compose exec apache /usr/sbin/a2ensite  004-website04

#- refrescar i apuntar 
docker-compose exec apache /usr/sbin/apache2ctl restart

### -- 
##  -- etapa 2 - validar que ho hem aconseguit
### -- 

# accedint per ip a les webs dels comptes del sistema creats a tal efecte.
for i in {0..3}; do 
	echo -e "\n${yellow}Validació: comprovació des del client (web de ${LLISTA_COMPTES[i]}) ${endColor}\n";
  docker-compose exec textclient curl 10.28.1.100/~${LLISTA_COMPTES[i]}/
done

### -- 
##  -- etapa 3 - 
### -- 

### -- 
##  -- etapa 4 -
### -- 

### -- 
##  -- etapa 5 - 
### -- 
