#!/bin/sh

if [ -z "$(ls -A /home/npmuser/.bitcore)" ]; then
  cd /home/npmuser
  /sbin/setuser npmuser bitcore-node create . 2>&1
fi

cat <<__EOF2 > /home/npmuser/.bitcore/package.json
{
  "name": "npmuser",
  "version": "1.0.0",
  "description": "",
  "main": "index.js",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "keywords": [],
  "author": "",
  "license": "ISC"
}
__EOF2
chown npmuser:npmuser /home/npmuser/.bitcore/package.json

cd /home/npmuser/.bitcore
/sbin/setuser npmuser bitcore-node install insight-api 2>&1
/sbin/setuser npmuser bitcore-node install insight-ui 2>&1

###################

cat <<__EOF > /home/npmuser/.bitcore/data/bitcoin.conf
# server=1 tells Bitcoin-QT to accept JSON-RPC commands.
server=1

# You must set rpcuser and rpcpassword to secure the JSON-RPC api
rpcuser=${BITCOIND_USER}
rpcpassword=${BITCOIND_PASS}

rpcallowip=127.0.0.1
rpcallowip=172.16.0.0/12
rpcallowip=10.0.0.0/8

# Listen for RPC connections on this TCP port:
rpcport=${BITCOIND_PORT}

rpcworkqueue=128

whitelist=127.0.0.1
txindex=1
addressindex=1
timestampindex=1
spentindex=1
zmqpubrawtx=tcp://127.0.0.1:28332
zmqpubhashblock=tcp://127.0.0.1:28332
uacomment=bitcore
__EOF

####################

exec /sbin/setuser npmuser bitcore-node start 2>&1
