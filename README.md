docker-proxy-relay
==================

A docker container to forward traffic to an HTTP proxy relay.

It uses [redsocks](https://github.com/darkk/redsocks) to forward requests to a proxy. [go-any-proxy](https://github.com/ryanchapman/go-any-proxy) may be an alternative.

## Why?

To use docker behind http proxy at work.

1. start a docker container with cntlm and redsocks
2. set up an iptable rule to redirect everything incoming from network interface _docker0_ to the _proxy-relay-container_

## How to use it?

Obtain the startup script

    wget https://github.com/kops/docker-proxy-relay/raw/master/docker_proxy.sh
    chmod +x docker_proxy.sh

Start the proxy relay and redirect all docker containers outgoing traffic on port 80 to the _proxy-relay-container_

    ./docker_proxy.sh start <username> <proxy_host>:<proxy_port>
    <username> <proxy_host>:<proxy_port> password: xxxxxx

Stop the proxy relay:

    ./docker_proxy.sh stop

Get status:

    ./docker_proxy.sh status
