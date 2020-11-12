#!/bin/bash
set -x
WAITTIME=10
docker-compose -f docker-compose.yml up -d --scale dhcpclient=2 --scale dhcpserver1=1 --scale=dhcpserver2=1
sleep $WAITTIME
docker exec -it dhcpserver1 /bin/bash -c "grep -v kernel /var/log/syslog" | tee server1_1-syslog.txt
docker exec -it dhcpserver2 /bin/bash -c "grep -v kernel /var/log/syslog" | tee server2_1-syslog.txt
docker-compose -f docker-compose.yml up -d --scale dhcpclient=2 --scale dhcpserver1=0 --scale=dhcpserver2=1
sleep $WAITTIME
docker exec -it dhcpserver2 /bin/bash -c "grep -v kernel /var/log/syslog" | tee server2_2-syslog.txt
docker-compose -f docker-compose.yml up -d --scale dhcpclient=5 --scale dhcpserver1=0 --scale=dhcpserver2=1
sleep $WAITTIME
docker exec -it dhcpserver2 /bin/bash -c "grep -v kernel /var/log/syslog" | tee server2_3-syslog.txt
docker-compose -f docker-compose.yml up -d --scale dhcpclient=5 --scale dhcpserver1=1 --scale=dhcpserver2=1
sleep $WAITTIME
docker exec -it dhcpserver1 /bin/bash -c "grep -v kernel /var/log/syslog" | tee server1_4-syslog.txt
docker exec -it dhcpserver2 /bin/bash -c "grep -v kernel /var/log/syslog" | tee server2_4-syslog.txt
#  docker-compose -f docker-compose.yml up -d --scale dhcpclient=3 --scale dhcpserver1=1 --scale=dhcpserver2=1
#  sleep $WAITTIME
#  docker exec -it dhcpserver1 /bin/bash -c "grep -v kernel /var/log/syslog" | tee server1_5-syslog.txt
#  docker exec -it dhcpserver2 /bin/bash -c "grep -v kernel /var/log/syslog" | tee server2_5-syslog.txt
#  docker-compose -f docker-compose.yml up -d --scale dhcpclient=3 --scale dhcpserver1=1 --scale=dhcpserver2=0
#  sleep $WAITTIME
#  docker exec -it dhcpserver1 /bin/bash -c "grep -v kernel /var/log/syslog" | tee server1_6-syslog.txt
#  docker-compose -f docker-compose.yml up -d --scale dhcpclient=9 --scale dhcpserver1=1 --scale=dhcpserver2=0
#  sleep $WAITTIME
#  docker exec -it dhcpserver1 /bin/bash -c "grep -v kernel /var/log/syslog" | tee server1_7-syslog.txt
#  docker-compose -f docker-compose.yml up -d --scale dhcpclient=9 --scale dhcpserver1=1 --scale=dhcpserver2=1
#  sleep $WAITTIME
#  docker exec -it dhcpserver1 /bin/bash -c "grep -v kernel /var/log/syslog" | tee server1_8-syslog.txt
#  docker exec -it dhcpserver2 /bin/bash -c "grep -v kernel /var/log/syslog" | tee server2_8-syslog.txt
docker ps
