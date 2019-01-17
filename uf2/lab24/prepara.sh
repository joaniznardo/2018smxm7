#!/bin/bash
## --
## Cal executar aquest script per aconseguir pertànyer al grup docker (per executar els containers sense ser superusuari
su - $(whoami)

## Nota2: amb "su $(whoami)" no permet després obrir simultàniament tots els terminals. Moralitat: fes un pwd preèviament i copia el directori on estàs, o bé quan arranques el terminal fes el su - $(whoami) :)

## Nota: habitualment caldria fer su - $(whoami), però si estàs en aquest script vol dir que ja estàs a un directori de pràctiques i per tant millor continuar en aquest directori.
