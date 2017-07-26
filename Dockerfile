FROM node:7

RUN apt-get update && apt-get upgrade -y && apt-get install -y libzmq3-dev
RUN npm install --unsafe-perm -g bitcore-node
USER node
WORKDIR /home/node
RUN bitcore-node create insight
WORKDIR /home/node/insight
RUN bitcore-node install insight-api
RUN bitcore-node install insight-ui

VOLUME /home/node/insight/data
CMD /home/node/insight/node_modules/bitcore-node/bin/bitcore-node start

EXPOSE 3001 8333
