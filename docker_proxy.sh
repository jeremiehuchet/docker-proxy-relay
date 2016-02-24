#!/bin/bash

set -e

# defaults
domain=
proxy_host=localhost
proxy_port=3128
proxy_user=

# load from configuration
test -f config && . config

FORWARD_TO_PROXY="PREROUTING -i docker0 -p tcp --dport 80 -j REDIRECT --to 33128 -m comment --comment 'DOCKER_PROXY'"

case "$1" in
start)
  read -p "Proxy host: ($proxy_host) " input && proxy_host="${input:-$proxy_host}"
  read -p "Proxy port: ($proxy_port) " input && proxy_port="${input:-$proxy_port}"
  read -p "$proxy_host:$proxy_port username: ($proxy_user) " input && proxy_user="${input:-$proxy_user}"
  read -s -p "$proxy_user@$proxy_host:$proxy_port password: " proxy_pass && echo

  docker run --name docker-proxy -d -p 33128:3128 \
      -e username=$proxy_user \
      -e domain=$domain \
      -e password=$proxy_pass \
      -e proxy=$proxy_host:$proxy_port \
      kops/docker-proxy-relay:2.0
  sudo iptables -t nat -A $FORWARD_TO_PROXY
  sudo iptables -t nat -L -n
  ;;
stop)
  sudo iptables -t nat -D $FORWARD_TO_PROXY
  sudo iptables -t nat -L -n
  docker stop docker-proxy || docker kill docker-proxy
  docker rm docker-proxy
  ;;
status)
  docker ps | head -1
  docker ps | grep docker-proxy
  sudo iptables -t nat -L -n | grep "DOCKER PROXY"
  ;;
*)
  cat <<EOF
Usage: $0 start
       $0 stop
       $0 status
EOF
  ;;
esac
