# lab00
## containers en xarxa: dns i dhcp  proporcionat per docker. 

## l'objectiu d'aquest lab és comprovar que sense fer (pràcticament) res el propi sistema docker ens assegura que els contenidors reben ip en una xarxa personalitzada i que tanmateix, se poden fer ping entre ells gràcies al dns incorporat per docker (127.0.0.11)

### ./up.sh

- comprovar els dos contenidors 
  - docker exec -it dhcpclient bash
    - ip a
    - cat /etc/resolv.conf
    - ping {nom_altre_contenidor}
    - exit

### ./down.sh


