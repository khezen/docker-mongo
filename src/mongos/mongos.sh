#!/bin/bash

if [ "$AUTH" == "y" ] && [ ! -f /config/key ]; then
  /run/auth/create_keyfile.sh
  touch /config/.admin_created
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

if [ "$AUTH" == "y" ] && [ -f /config/key ]; then
  cmd="$cmd --keyFile /config/key"
fi

echo $cmd
