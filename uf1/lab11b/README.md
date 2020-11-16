# lab11b  
  
## servidor dns dnsmasq - una única xarxa - creació d'un domini i assignació de clients  


## molt important  
  
## per a la creació del lab:  (20201116)
- dependències: ens assegurem que els servidors engeguen abans que els clients
- fitxers de configuració: s'incorporen als contenidors amb els paràmetres correctes abans de l'execució dels serveis: ens estalviem la fase de còpia en un procés posterior.
- resolució de noms: cal inhabilitar la que proporciona el propi docker desmuntant el fitxer /etc/resolv.conf

