#!/bin/bash
set -e

echo -e "\n[Info]: Updating packages & Installing HA Proxy\n"

sudo apt-get update && sudo apt-get upgrade -y

sudo apt-get install haproxy -y

echo -e "\n[Info]: Configuring HA Proxy with our master private IPs\n"

cat <<EOF | sudo tee /etc/haproxy/haproxy.cfg 
frontend fe-apiserver
   bind 0.0.0.0:6443
   mode tcp
   option tcplog
   default_backend be-apiserver

backend be-apiserver
   mode tcp
   option tcplog
   option tcp-check
   balance roundrobin
   default-server inter 10s downinter 5s rise 2 fall 2 slowstart 60s maxconn 250 maxqueue 256 weight 100

       server master-1 172.31.45.15:6443 check port 6443
       server master-2 172.31.36.106:6443 check port 6443
       server master-3 172.31.19.241:6443 check port 6443
EOF

echo -e "\n[Info]: Restarting HA-Proxy service\n"

sudo service haproxy restart