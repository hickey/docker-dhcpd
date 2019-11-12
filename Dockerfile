FROM ubuntu:18.04

MAINTAINER Gerard Hickey <hickey@kinetic-compute.com>

ARG DEBIAN_FRONTEND=noninteractive

ENV FOREMAN_VERSION 1.16
RUN echo "deb http://deb.theforeman.org/ jessie $FOREMAN_VERSION" > /etc/apt/sources.list.d/foreman.list && \
    echo "deb http://deb.theforeman.org/ plugins $FOREMAN_VERSION" >> /etc/apt/sources.list.d/foreman.list && \
    apt-get -y update && apt-get -y upgrade  && \
    apt-get -q -y -o "DPkg::Options::=--force-confold" -o "DPkg::Options::=--force-confdef" install apt-utils && \
    apt-get -q -y -o "DPkg::Options::=--force-confold" -o "DPkg::Options::=--force-confdef" dist-upgrade && \
    apt-get -q -y -o "DPkg::Options::=--force-confold" -o "DPkg::Options::=--force-confdef" install isc-dhcp-server && \
    apt-get -y --allow-unauthenticated install foreman-proxy && \
    gem install bundler_ext rack sinatra concurrent-ruby && \
    apt-get -q -y autoremove && \
    apt-get -q -y clean && \
    rm -rf /var/lib/apt/lists/*

COPY semi.conf /etc/semi.conf
COPY foreman-proxy/ /etc/foreman-proxy/
COPY dumb-init_1.2.0_amd64 /usr/bin/dumb-init
COPY entrypoint.sh /entrypoint.sh

EXPOSE "8443"

ENTRYPOINT ["semi"]
