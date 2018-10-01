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
echo "ip informada per docker del client" `docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' dhcpclient`| tee -a resultat.txt
echo "mac informada per docker del servidor" `docker inspect --format='{{range .NetworkSettings.Networks}}{{.MacAddress}}{{end}}' dhcpserver`| tee -a resultat.txt
echo "mac informada per docker del client" `docker inspect --format='{{range .NetworkSettings.Networks}}{{.MacAddress}}{{end}}' dhcpclient`| tee -a resultat.txt
echo "-------------------------------------"| tee -a resultat.txt


#############################
## configuració del servidor
#############################

# -- "injectem" la configuració en el container: ens ajudem del client docker perquè mitjançant el servidor docker incorpore el fitxer de configuració al contenidor: (CM configuration management)
docker cp dhcp.conf.template  dhcpserver:/etc/dnsmasq.d/dhcp.conf

# -- activem el servei (per si aturem el container...)
## - 16.04 - docker exec dhcpserver /bin/bash -c "systemctl enable dnsmasq; systemctl status dnsmasq"
docker exec dhcpserver /bin/bash -c "update-rc.d dnsmasq enable; service  dnsmasq status"

# -- iniciem el servei 
## - 16.04 - docker exec dhcpserver /bin/bash -c "systemctl start dnsmasq; systemctl status dnsmasq"
docker exec dhcpserver /bin/bash -c "service dnsmasq start; service dnsmasq  status"
sleep 1 

#############################
## renovació de la ip del client 
#############################

# -- alliberem la ip assignada per docker (en realitat nosaltres - és estàtica)
docker exec dhcpclient /bin/bash -c "ip addr flush eth0"

# -- demanem una ip "a qui pugui escoltar" (servidor de dhcp, doncs ens hem acabat les ips amb el hack "ip-range" a docker-compose)
docker exec dhcpclient /bin/bash -c "dhclient eth0"

#############################
## comprovacions després dels canvis
#############################
echo "====================================="| tee -a resultat.txt
echo "DESPRÉS d'activar el servidor i sol.licitar ip al client"| tee -a resultat.txt
echo "ip real del servidor : " `docker exec dhcpserver /bin/bash -c "ip -4 a" | grep inet | grep eth0 | awk '{print $2}'`| tee -a resultat.txt
echo "ip real del client : " `docker exec dhcpclient /bin/bash -c "ip -4 a" | grep inet | grep eth0 | awk '{print $2}'`| tee -a resultat.txt
echo "ip informada per docker del servidor" `docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' dhcpserver`| tee -a resultat.txt
echo "ip informada per docker del client" `docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' dhcpclient`| tee -a resultat.txt
echo "mac informada per docker del servidor" `docker inspect --format='{{range .NetworkSettings.Networks}}{{.MacAddress}}{{end}}' dhcpserver`| tee -a resultat.txt
echo "mac informada per docker del client" `docker inspect --format='{{range .NetworkSettings.Networks}}{{.MacAddress}}{{end}}' dhcpclient`| tee -a resultat.txt
echo "-------------------------------------"| tee -a resultat.txt

