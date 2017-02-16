FROM quantumobject/docker-baseimage:16.04
MAINTAINER <info@monaco-ex.org>

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-add-repository ppa:bitcoin/bitcoin
RUN curl -sL https://deb.nodesource.com/setup_4.x | sudo bash -
RUN apt-get -y install bitcoind nodejs git python build-essential
RUN apt-get -y dist-upgrade

EXPOSE 3001

RUN mkdir /etc/service/insight
ADD insight.sh /etc/service/insight/run

#RUN mkdir /etc/service/bitcoind
#ADD bitcoind.sh /etc/service/bitcoind/run

RUN mkdir /datadir
VOLUME /datadir

USER root
RUN sudo npm -g install npm@3.5.3
RUN useradd -ms /bin/bash npmuser

USER npmuser
WORKDIR /home/npmuser
RUN npm install bitcore-node@2.1.1
RUN node_modules/bitcore-node/bin/bitcore-node create mynode

USER root
ADD bitcore-node.json /home/npmuser/mynode/bitcore-node.json
RUN chown npmuser /home/npmuser/mynode/bitcore-node.json

USER npmuser
WORKDIR /home/npmuser/mynode
RUN node_modules/bitcore-node/bin/bitcore-node install insight-api
RUN node_modules/bitcore-node/bin/bitcore-node install insight-ui

USER root
WORKDIR /
RUN apt-get -y autoremove gcc g++ build-essential git make

ENV BITCOIND_USER=bitcoin
ENV BITBITCOIND_PASS=bitcoinpass
ENV INSIGHT_IP="127.0.0.1"
ENV BITCOIND_HOST="127.0.0.1"
ENV BITCOIND_PORT=8332
ENV BITCOIND_DATADIR=/datadir

CMD ["/sbin/my_init"]
