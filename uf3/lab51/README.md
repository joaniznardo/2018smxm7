# lab51 - el teu primer servidor proxy ...amb accés NO segur (http) ... i filtrat de webs i continguts
## servidor squid: 

- l'obectiu d'aquest lab és accedir a un servidor apache via servidor proxy (squid)

- exemples d'ús: 
  - optimitzat l'ample de banda
  - filtrar els accessos 
  - registrar accessos

- Lab per practicar les transferàncies de client a servidor i vice-versa.
molt important: a diferència dels anterior labs ens limitarem a crear els containers amb ip fixa i el dns del propi docker


## inclosos 3 scripts per facilitar l'execució:

- prepara.sh - quan no pots executar docker per falta de permissos...
- neteja.sh - quan no pots executar el lab perquè el darrer cop no tancares amb un ./down.sh. Si hi ha algun contenidor executant-se no l'atura!!! Cal fer un docker stop <container_name>  i un docker rm <container_name>!!
- update_all.sh - assegurar-se de disposar de les imatges actualitzades ;) (run once)

## referències
- [apache web server](https://httpd.apache.org/)
- [ngnix](https://www.nginx.com/)
- [squid](http://www.squid-cache.org/)
