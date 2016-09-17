#!/bin/bash

set -m

mongodb_cmd="mongod --storageEngine $storage_engine"
cmd="$mongodb_cmd --httpinterface --rest"

if [ "$SHARD" == "yes" ]; then
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

mongo admin --eval "db.getSiblingDB('admin').runCommand({setParameter: 1, internalQueryExecYieldPeriodMS: 1000});"
mongo admin --eval "db.getSiblingDB('admin').runCommand({setParameter: 1, internalQueryExecYieldIterations: 100000});"

if [ ! -f "$dbpath"/.mongodb_password_set ]; then
  /set_auth.sh
fi

fg
