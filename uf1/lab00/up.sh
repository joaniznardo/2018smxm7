#!/bin/bash

docker-compose -f docker-compose.yml up -d
sleep 2 
docker-compose scale dhcpclient=3
## fem les proves "des de fora :)"

# comprovem el resolv.conf
echo "---------------------------- fitxer /etc/resolv.conf -------"
docker exec -it lab00_dhcpclient_1 sh -c "cat /etc/resolv.conf" 
echo "  "

# comprovació de la ip (des del propi container)
echo "---------------------------- comprovació de les ips  -------"
docker exec -it lab00_dhcpclient_1 sh -c "ip a"
echo "  "

# comprovació de la resolucio de noms per fitxer
echo "---------------------------- contingut de /etc/hosts -------"
docker exec -it lab00_dhcpclient_1 sh -c "cat /etc/hosts"
echo "  "

# prova de connectivitat
echo "---------------------------- ping a dhcpclient_1     -------"
docker exec -it lab00_dhcpclient_1 sh -c "ping -c 2 lab00_dhcpclient_1" 
echo "  "
echo "---------------------------- ping a dhcpclient_2     -------"
docker exec -it lab00_dhcpclient_1 sh -c "ping -c 2 lab00_dhcpclient_2" 
echo "  "
echo "---------------------------- ping a dhcpclient_3     -------"
docker exec -it lab00_dhcpclient_1 sh -c "ping -c 2 lab00_dhcpclient_3" 
echo "  "
