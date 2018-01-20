FROM node:0.10.48

WORKDIR /
RUN git clone https://github.com/BitzenyCoreDevelopers/insight-ui-bitzeny.git
RUN git clone https://github.com/BitzenyCoreDevelopers/insight-api-bitzeny.git
WORKDIR /insight-api-bitzeny
RUN npm install
WORKDIR /insight-ui-bitzeny

ENV INSIGHT_FORCE_RPC_SYNC=1
ENV INSIGHT_PUBLIC_PATH=public
ENV BITCOIND_USER=user
ENV BITCOIND_PASS=password
ENV INSIGHT_NETWORK=livenet
ENV INSIGHT_PORT=3000

EXPOSE 3000

ENTRYPOINT node /insight-api-bitzeny/insight.js
