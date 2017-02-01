#!/bin/bash

if [ "$AUTH" == "y" ] && [ ! -f /config/key ]; then
  /run/auth/create_keyfile.sh
fi

cmd="mongod --storageEngine $STORAGE_ENGINE --port 27017"
if [ "$SHARD_SVR" == "y" ]; then
    cmd="$cmd --shardsvr"
fi
if [ "$RS_NAME" != "" ]; then
    cmd="$cmd --replSet $RS_NAME"
fi

if [ "$DATA_PATH" != "" ]; then
    mkdir -p $DATA_PATH
    cmd="$cmd --dbpath $DATA_PATH"
fi
if [ "$OPLOG_SIZE" != "" ]; then
    cmd="$cmd --oplogSize $OPLOG_SIZE"
fi
if [ "$CONFIG_SVR" == "y" ]; then
    cmd="$cmd --configsvr"
fi

if [ "$AUTH" == "y" ] && [ -f /config/key ]; then
  cmd="$cmd --keyFile /config/key"
fi

echo $cmd
