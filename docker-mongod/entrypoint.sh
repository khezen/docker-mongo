#!/bin/bash

set -m

mongodb_cmd="mongod --storageEngine $STORAGE_ENGINE"
cmd="$mongodb_cmd --httpinterface --rest --master"

if [ "$SHARD" == "yes" ]; then
  cmd="$cmd --shardsvr"
fi

if [ "$REPLICA_SET_NAME" != "" ]; then
  cmd="$cmd --replSet $REPLICA_SET_NAME"
fi

if [ "$AUTH" == "yes" ]; then
  cmd="$cmd --auth"
fi

if [ "$DBPATH" != "" ]; then
  mkdir -p "$DBPATH"
  cmd="$cmd --dbpath $DBPATH"
fi

if [ "$OPLOG_SIZE" != "" ]; then
  cmd="$cmd --oplogSize $OPLOG_SIZE"
fi

$cmd &

RET=1
while [[ RET -ne 0 ]]; do
    echo "=> Waiting for confirmation of MongoDB service startup"
    sleep 5
    mongo admin --eval "help" >/dev/null 2>&1
    RET=$?
done

mongo admin --eval "db.getSiblingDB('admin').runCommand({setParameter: 1, internalQueryExecYieldPeriodMS: 1000});"
mongo admin --eval "db.getSiblingDB('admin').runCommand({setParameter: 1, internalQueryExecYieldIterations: 100000});"

if [ ! -f "$DBPATH"/.mongodb_password_set ]; then
  /set_auth.sh
fi

echo "MongoDB is running!"

fg
