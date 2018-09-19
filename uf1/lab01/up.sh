#!/bin/bash

docker-compose -f docker-compose.yml up -d
sleep 1

echo "====================================="| tee resultat.txt
echo "elements actius: "| tee -a resultat.txt
docker-compose ps| tee -a resultat.txt
echo "-------------------------------------"| tee -a resultat.txt

#############################
## comprovacions abans dels canvis
#############################
echo "====================================="| tee -a resultat.txt
echo "ABANS d'activar el servidor i sol.licitar ip al client"| tee -a resultat.txt
echo "ip real del servidor : " `docker exec dhcpserver /bin/bash -c "ip -4 a" | grep inet | grep eth0 | awk '{print $2}'`| tee -a resultat.txt
echo "ip real del client : " `docker exec dhcpclient /bin/bash -c "ip -4 a" | grep inet | grep eth0 | awk '{print $2}'`| tee -a resultat.txt
echo "ip informada per docker del servidor" `docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' dhcpserver`| tee -a resultat.txt
echo "ip informada per docker del servidor" `docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' dhcpclient`| tee -a resultat.txt
echo "mac informada per docker del servidor" `docker inspect --format='{{range .NetworkSettings.Networks}}{{.MacAddress}}{{end}}' dhcpserver`| tee -a resultat.txt
echo "mac informada per docker del servidor" `docker inspect --format='{{range .NetworkSettings.Networks}}{{.MacAddress}}{{end}}' dhcpclient`| tee -a resultat.txt
echo "-------------------------------------"| tee -a resultat.txt


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
echo "====================================="| tee -a resultat.txt
echo "DESPRÉS d'activar el servidor i sol.licitar ip al client"| tee -a resultat.txt
echo "ip real del servidor : " `docker exec dhcpserver /bin/bash -c "ip -4 a" | grep inet | grep eth0 | awk '{print $2}'`| tee -a resultat.txt
echo "ip real del client : " `docker exec dhcpclient /bin/bash -c "ip -4 a" | grep inet | grep eth0 | awk '{print $2}'`| tee -a resultat.txt
echo "ip informada per docker del servidor" `docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' dhcpserver`| tee -a resultat.txt
echo "ip informada per docker del servidor" `docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' dhcpclient`| tee -a resultat.txt
echo "mac informada per docker del servidor" `docker inspect --format='{{range .NetworkSettings.Networks}}{{.MacAddress}}{{end}}' dhcpserver`| tee -a resultat.txt
echo "mac informada per docker del servidor" `docker inspect --format='{{range .NetworkSettings.Networks}}{{.MacAddress}}{{end}}' dhcpclient`| tee -a resultat.txt
echo "-------------------------------------"| tee -a resultat.txt

