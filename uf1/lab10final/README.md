# lab10final
## servidor dhcp isc-dhcp + bind9 (alimentat per dhcp) - una única xarxa 
[referencia](https://blog.bigdinosaur.org/running-bind9-and-isc-dhcp/)

# TLDR; 
## deixem que el dhcp emplene el diccionari dns (pseudo "clau-valor")

### Per a la realització d'aquests labs (dhcp) i atés que docker assigna una ip de manera automàtica als contenidors associats a una xarxa, farem servir el següent hack

- se crea una xarxa (paràmetre subnet)
- se limiten el nombre de ips a repartir (/30 - és la màscara habitual en una xarxa punt a punt: sols hi ha dues adreces disponibles de les 4 possibles, doncs la 1era especifica la xarxa i l'última l'adreça de difusió.  
Se bloquegen les ips disponibles, inclosa la de difusió - que a docker també és hàbil (a data 20180801).  
S'assignen de manera manual les ips als contenidors.   
S'allibera la ip assignada de forma estàtica.  
Per fer que s'actualitze el /etc/resolv.conf (gestionat per docker) se desfà el muntatge del fitxer associat al resolv.conf generat per docker.
Se demana una ip al servidor de dhcp.  

### FAQS
- q: se pot demanar ip i alliberar la que proporciona docker?
- a: 


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

