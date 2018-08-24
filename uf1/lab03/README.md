# lab03
## servidor dhcp dnsmasq - una única xarxa amb redundància (no coordinada)

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
  - crear més containers que les ips possibles d'un dels dos servidors 
  - aturar un dels servidors i comprovar que podem continuar creant/renovant ips (de l'altre servidor, és clar)
  - aturar els dos servidors


- fitxers a observar:
  - en el servidor: 
    - ips assignades
  - en el client:
    - període de concesió de la ip

- ampliacions:
  - portar el control centralitzat de les ips assignades (IPAM - phpipam vs opennetadmin)
  - crear redundància no coordinada (conjunts disjunts d'ips) amb més de 2 servidors (3,4 o 5)
