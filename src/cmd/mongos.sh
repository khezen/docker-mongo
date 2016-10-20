#!/bin/bash

mkdir -p $dbpath
cmd="mongos --port 27017 --configdb"
concat_servers=""
for config_server in $config_servers; do
    if [ "$concat_servers" == "" ]; then
        concat_servers="$config_server"
    else
        concat_servers="$concat_servers,$config_server"
    fi
done
cmd="$cmd $concat_servers"

echo $cmd