# Activitats proposades pel lab19

## 0) Bàsic: Observa que hi ha a cada fitxer:

### docker-compose - arquitectura del lab
### up.sh - atenció a 1) la nova xarxa, 2) l'establiment del "reenviament" entre les diferents interfícies del "router" i 3) l'establiment de la passarel·la als clients 
### named.conf.local - declaració de les zones (dominis): 2 zones per cada domini: per a la resolució directa i inversa. Atenció a ON escolten els servidors!!
### named.conf.options - inclusió dels nous elements que poden preguntar al servidor de domini (no volem "oferir-lo" a la comunitat)

## 0.1) Fàcil: anota en un full de càlcul al google drive el resum del que has trobat (confirma el que hi ha en aquest document) 

## 1) Partint del lab 18 arribar al lab 19

### 1.1) Fàcil: compara les diferències entre fitxers (diff -y fitx1 fitx2) i modifica els fitxers del lab 18 (o millor si has creat el directori lab18c)
### 1.2) Posa't a prova: Igual però sense mirar el lab19 (sempre estarà ahí esperan-te) 

## 2) Fer que el 2on domini se gestione al 2on servidor: d'aquesta manera tindríem un servidor que actua com a primari per a una zona i secundàri per a l'altra, mentre que l'altre servidor actuarà com a secundari per a la primera zona i primari a la segona zona

## 3) Hardcore: Crea una tercera xarxa connectada al router, dnsserver1 i dnsserver2 per que gestione dos clients més de la nova xarxa.
