#!/bin/bash

set -m

cmd="mongod --storageEngine $storage_engine"

if [ "$shard" == "yes" ]; then
  cmd="$cmd --shardsvr"
fi

if [ "$rs_name" != "" ]; then
  cmd="$cmd --replSet $rs_name"
fi

if [ "$auth" == "yes" ]; then
  cmd="$cmd --auth"
fi

if [ "$dbpath" != "" ]; then
  mkdir -p "$dbpath"
  cmd="$cmd --dbpath $dbpath"
fi

if [ "$oplog_size" != "" ]; then
  cmd="$cmd --oplogSize $oplog_size"
fi

echo $cmd

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

if [ ! -f "$dbpath"/.mongodb_password_set ]; then
  /set_auth.sh
fi

echo "mongod server succesfully started"

fg
