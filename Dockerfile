FROM quantumobject/docker-baseimage:16.04
MAINTAINER <info@monaco-ex.org>

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -y update
RUN apt-get -y upgrade
#RUN apt-get -y install software-properties-common
#RUN apt-add-repository ppa:bitcoin/bitcoin
RUN curl -sL https://deb.nodesource.com/setup_4.x | bash -
RUN apt-get -y install nodejs git python build-essential libzmq3-dev
RUN apt-get -y dist-upgrade

EXPOSE 3001

RUN mkdir /etc/service/insight
ADD insight.sh /etc/service/insight/run
ADD setuser /sbin/setuser

#RUN mkdir /etc/service/bitcoind
#ADD bitcoind.sh /etc/service/bitcoind/run

RUN useradd -ms /bin/bash npmuser

RUN mkdir -p /home/npmuser/.bitcore && chown npmuser:npmuser /home/npmuser/.bitcore
VOLUME /home/npmuser/.bitcore

RUN npm install -g bitcore-node@latest bitcore-lib insight-api insight-ui

USER npmuser
WORKDIR /home/npmuser
RUN npm init -f

USER root
RUN apt-get -y autoremove gcc g++ build-essential git make software-properties-common

ENV BITCOIND_USER=bitcoin
ENV BITCOIND_PASS=bitcoinpass
ENV BITCOIND_PORT=8332

CMD ["/sbin/my_init"]
