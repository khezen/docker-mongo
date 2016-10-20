#!/bin/bash

if [ "$config_servers" != "" ]; then 
  cmd=$(/run/cmd/mongos.sh)
else
  cmd=$(/run/cmd/mongod.sh)
fi

if [ "$auth" == "y" ] && [ -f "$dbpath"/.mongodb_password_set ]; then
  cmd="$cmd --keyFile /data/db/config/key"
fi

echo $cmd