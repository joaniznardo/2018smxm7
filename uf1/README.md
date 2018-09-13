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
  
## DNS
- assignació de noms  a ip(v4 inicialment)
- resolució directa i inversa
- redundància en el servidor (com gestionar que no sols depenem d'un únic element: accions a server i client)
- autoconfiguració del registre dns a ipv4
