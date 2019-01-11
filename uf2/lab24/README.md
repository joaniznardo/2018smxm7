# lab23
## servidor tftp: tftp-hpa: servidor ja instal·lat: accés sense autenticació (lectura i escriptura en directoris separats)

- exemples d'ús: lloc on enviar fitxers de configuració i d'on recurerar isos / binaris del sistema (so cisco per switch/router)...


- Lab per practicar les transferàncies de client a servidor i vice-versa.
molt important: a diferència dels anterior labs ens limitarem a crear els containers amb ip fixa i el dns del propi docker


## inclosos 3 scripts per facilitar l'execució:

- prepara.sh - quan no pots executar docker per falta de permissos...
- neteja.sh - quan no pots executar el lab perquè el darrer cop no tancares amb un ./down.sh
- update_all.sh - assegurar-se de disposar de les imatges actualitzades ;) (run once)

## referències
- [configuracio](https://medium.com/@Sciri/configuring-a-tftp-server-on-ubuntu-for-switch-upgrades-and-maintenance-caf5b6833148)
- [seguretat](https://manpages.debian.org/jessie/tftpd-hpa/tftpd.8.en.html)
