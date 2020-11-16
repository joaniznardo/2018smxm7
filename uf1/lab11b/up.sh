#!/bin/bash

## en cas de voler detall de què passa realment (màgia oculta)
## docker-compose --verbose -f docker-compose.yml up -d
docker-compose -f docker-compose.yml up -d
sleep 2

docker exec -it dhcpdnsserver ip a
docker exec -it dhcpdnsserver ip r
docker exec -it dhcpdnsserver cat /etc/resolv.conf


## per resoldre els noms a partir del dnsserver i no del /etc/hosts
## -- ## docker exec dhcpclient /bin/bash -c "sed -i -e '/hosts/s/files dns/dns files/g' /etc/nsswitch.conf"

