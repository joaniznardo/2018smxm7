# lab10test20
## servidor dhcp isc-dhcp - dues xarxes - paràmetres addicionals: passarel·la

## comprova tots 4 clients reben ip i fan ping a google; 
## indica si hi ha algun que no rep ip quin eś el motiu;
## indica si hi ha algun client que no fa ping quin és el motiu;

### Per a la realització d'aquests labs (dhcp) i atés que docker assigna una ip de manera automàtica als contenidors associats a una xarxa, farem servir el següent hack

- se crea una xarxa (paràmetre subnet)
- se limiten el nombre de ips a repartir (/30 - és la màscara habitual en una xarxa punt a punt: sols hi ha dues adreces disponibles de les 4 possibles, doncs la 1era especifica la xarxa i l'última l'adreça de difusió. Se bloquegen les ips disponibles, inclosa la de difusió - que a docker també és hàbil (a data 20180801). S'assignen de manera manual les ips als contenidors. Se sol·licita una ip al servidor, fent que aparega una segona ip assignada del rang. Opcional: si s'alliberen les ips, s'alliberen totes dues i si se torna a demanar, ara ja s'assignarà una única ip.)

