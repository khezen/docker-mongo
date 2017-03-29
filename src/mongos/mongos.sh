#!/bin/bash

if [ "$AUTH" == "y" ]; then
  /run/auth/create_keyfile.sh
  touch /data/db/.metadata/.admin_created
fi

cmd="mongos --port 27017 --configdb"
concat_servers=""
for config_server in $CONFIG_SERVERS; do
    if [ "$concat_servers" == "" ]; then
        concat_servers="$config_server"
    else
        concat_servers="$concat_servers,$config_server"
    fi
done
cmd="$cmd $concat_servers"

if [ "$AUTH" == "y" ] && [ -f /.key ]; then
  cmd="$cmd --keyFile /.key"
fi

echo $cmd
