#!/bin/bash

if [ "$config_servers" != "" ]; then 
  cmd=$(/run/cmd/mongos.sh)
else
  cmd=$(/run/cmd/mongod.sh)
fi

if [ "$auth" == "y" ] && [ -f /config/key ]; then
  cmd="$cmd --keyFile /config/key"
fi

echo $cmd