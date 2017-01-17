#!bin/bash

set -m

if [ "$CONFIG_SERVERS" == "" ]; then
  /run/mongod/entrypoint.sh &
else
  /run/mongos/entrypoint.sh &
fi

fg