#!/bin/sh

cd /home/npmuser/mynode
exec /sbin/setuser npmuser node_modules/bitcore-node/bin/bitcore-node start >> /var/log/insight.log 2>&1
