# UF1 - DHCP i DNS
## DHCP
- en xarxes ip cada interfície de xarxa (NIC) cal que tinga una ip (v4 i/o v6)
- l'assignació pot ser manual (SIC) o automàtica
- se pot realitzar des de dispositius de xarxa (router|switch) o des de servidors dedicats (baremetal|vm|container)
- aspectes a tindre en consideració:
  - quants dispositius necessiten ip (...i altres paràmetres)
  - quins paràmetres s'envia al client
  - durant quant de temps
  - quantes xarxes vaig a configurar automàticament
  - redundància (o no): nombre de servidors (coordinats|no coordinats|no desitjats)
  - actuació del client (paràmetres que sol·licita)
  
### links
#### dhcp - basic & detailed
- [bàsic1](https://www.netmanias.com/en/?m=view&id=blog&no=6003)
- [bàsic2](https://www.netmanias.com/en/?m=view&id=techdocs&no=5998)
- [bàsic3](https://www.netmanias.com/en/?m=view&id=techdocs&no=5999)

#### dhcp - relay agents
- [relay1](https://www.netmanias.com/en/?m=view&id=blog&no=6004)
- [relay2](https://www.netmanias.com/en/?m=view&id=techdocs&no=6000)
- [relay3](https://www.netmanias.com/en/post/techdocs/6000/dhcp-network-protocol/understanding-dhcp-relay-agents)

#### dhcp - proxy agents 
- [proxy1](https://www.netmanias.com/en/?m=view&id=techdocs&no=6001)


## DNS
- assignació de noms  a ip(v4 inicialment)
- resolució directa i inversa
- redundància en el servidor (com gestionar que no sols depenem d'un únic element: accions a server i client)
- autoconfiguració del registre dns a ipv4
