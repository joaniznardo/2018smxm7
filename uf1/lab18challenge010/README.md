# lab18
## servidor dns bind - una única xarxa - creació d'un servidor de domini autoritari (de referència) amb un servidor de recolzament.

## molt important

### Problema inicial i resolució temporal/funcional (o definitiva) de l'ús de docker amb la gestió del client de dns: /etc/resolv.conf
- docker munta el seu propi subsistema de dns tenint els containers un nameserver 127.0.0.11 a /etc/resolv.conf
- aquest fitxer no se pot (o no sé a data de 20180827)  modificar des de'l servidor dnsmasq (que sí que envia la info: /etc/resolv.conf-dhclient-new.XXXX)
- aprofitant que sí que s'envia la informació preparem amb l'ajuda de inotify-tools (inotifywait) per un nou fitxer a /etc que continga en el nom dhclient i llavors se còpia sobre /etc/resolv.conf (amb el perill que si el servidor dnsmasq no reenvia les peticions dns que no sap resoldre, els containers se quedaran sense accés a l'exterior.

# (parcial en aquest lab: assignació directa de ip al docker-compose)
### Per a la realització d'aquests labs (dhcp) i atés que docker assigna una ip de manera automàtica als contenidors associats a una xarxa, farem servir el següent hack

- se crea una xarxa (paràmetre subnet)
- se limiten el nombre de ips a repartir (/30 - és la màscara habitual en una xarxa punt a punt: sols hi ha dues adreces disponibles de les 4 possibles, doncs la 1era especifica la xarxa i l'última l'adreça de difusió. Se bloquegen les ips disponibles, inclosa la de difusió - que a docker també és hàbil (a data 20180801). S'assignen de manera manual les ips als contenidors. Se sol·licita una ip al servidor, fent que aparega una segona ip assignada del rang. Opcional: si s'alliberen les ips, s'alliberen totes dues i si se torna a demanar, ara ja s'assignarà una única ip.)



## execució del lab:
### ./up.sh

- comprovar els dos contenidors 
  - docker exec -it dhcpclient bash
    - ip a
    - exit

### ./down.sh

- proves a efectuar: 
  - crear més containers que interval
  - provar d'assignar ip + passarel·la + dns server

- fitxers a observar:
  - en el servidor: 
    - ips assignades
  - en el client:
    - període de concesió de la ip

- ampliacions:
  - portar el control centralitzat de les ips assignades (IPAM - phpipam vs opennetadmin)

