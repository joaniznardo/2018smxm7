#!/bin/bash

docker-compose -f docker-compose.yml up -d
sleep 1

echo "====================================="
echo "elements actius: "
docker-compose ps
echo "-------------------------------------"

#############################
## comprovacions abans dels canvis
#############################
echo "====================================="
echo "ABANS d'activar el servidor i sol.licitar ip al client"
echo "ip real del servidor abans canvis: " `docker exec dhcpserver /bin/bash -c "ip -4 a" | grep inet | grep eth0 | awk '{print $2}'`
echo "ip real del client abans canvis: " `docker exec dhcpclient /bin/bash -c "ip -4 a" | grep inet | grep eth0 | awk '{print $2}'`
echo "ip informada per docker del servidor" `docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' dhcpserver`
echo "ip informada per docker del servidor" `docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' dhcpclient`
echo "mac informada per docker del servidor" `docker inspect --format='{{range .NetworkSettings.Networks}}{{.MacAddress}}{{end}}' dhcpserver`
echo "mac informada per docker del servidor" `docker inspect --format='{{range .NetworkSettings.Networks}}{{.MacAddress}}{{end}}' dhcpclient`
echo "-------------------------------------"


#############################
## configuració del servidor
#############################

docker cp dhcp.conf.template  dhcpserver:/etc/dnsmasq.d/dhcp.conf
docker exec dhcpserver /bin/bash -c "service dnsmasq restart;service dnsmasq status"
sleep 1 

#############################
## renovació de la ip del client 
#############################

docker exec dhcpclient /bin/bash -c "dhclient eth0; dhclient -r eth0; dhclient eth0"

#############################
## comprovacions després dels canvis
#############################
echo "====================================="
echo "DESPRÉS d'activar el servidor i sol.licitar ip al client"
echo "ip real del servidor abans canvis: " `docker exec dhcpserver /bin/bash -c "ip -4 a" | grep inet | grep eth0 | awk '{print $2}'`
echo "ip real del client abans canvis: " `docker exec dhcpclient /bin/bash -c "ip -4 a" | grep inet | grep eth0 | awk '{print $2}'`
echo "ip informada per docker del servidor" `docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' dhcpserver`
echo "ip informada per docker del servidor" `docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' dhcpclient`
echo "mac informada per docker del servidor" `docker inspect --format='{{range .NetworkSettings.Networks}}{{.MacAddress}}{{end}}' dhcpserver`
echo "mac informada per docker del servidor" `docker inspect --format='{{range .NetworkSettings.Networks}}{{.MacAddress}}{{end}}' dhcpclient`
echo "-------------------------------------"

