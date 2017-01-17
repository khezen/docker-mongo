#!/bin/bash
cmd=$(/run/mongod/mongod.sh)
if [ "$AUTH" == "y" ] && [ -f /config/key ]; then
  cmd="$cmd --keyFile /config/key"
fi
echo $cmd
$cmd