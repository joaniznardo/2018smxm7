#!/bin/bash

# gnome edition
docker-compose ps | tail -n+2 | awk '{print $1}' | xargs -n 1 -I {} gnome-terminal --tab --title {} -e 'bash -c "docker exec -it {} bash "'

#  conservative edition (uncomment (try) this if above one fails)
## docker-compose ps | tail -n+2 | awk '{print $1}' | xargs -I {} sh -c 'xterm  -T {} -e "docker exec -it {} bash "&'
