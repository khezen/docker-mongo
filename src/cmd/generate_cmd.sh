#!/bin/bash

if [ "$CONFIG_SERVERS" != "" ]; then 
  cmd=$(/run/cmd/mongos.sh)
else
  cmd=$(/run/cmd/mongod.sh)
fi

if [ "$AUTH" == "y" ] && [ -f /config/key ]; then
  cmd="$cmd --keyFile /config/key"
fi

echo $cmd