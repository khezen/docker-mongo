#!/bin/bash

cmd="mongod --storageEngine $storage_engine --port 27017"
if [ "$shardsvr" == "y" ]; then
    cmd="$cmd --shardsvr"
fi
if [ "$rs_name" != "" ]; then
    cmd="$cmd --replSet $rs_name"
fi
if [ "$dbpath" != "" ]; then
    mkdir -p "$dbpath"
    cmd="$cmd --dbpath $dbpath"
fi
if [ "$oplog_size" != "" ]; then
    cmd="$cmd --oplogSize $oplog_size"
fi
if [ "$configsvr" == "y" ]; then
    cmd="$cmd --configsvr"
fi

echo $cmd