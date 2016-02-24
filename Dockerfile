FROM debian:stable

MAINTAINER Jeremie Huchet <jeremie@dudie.fr>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -qy \
 && apt-get upgrade -qy
RUN apt-get install -qy squid3 redsocks supervisor

ADD squid.conf /etc/squid3/squid.conf
ADD redsocks.conf /etc/redsocks.conf
COPY supervisor.conf.d /etc/supervisor/conf.d

VOLUME /etc/squid3/conf.d

EXPOSE 3128
EXPOSE 3129
EXPOSE 3130

CMD [ "supervisord", "-n" ]
