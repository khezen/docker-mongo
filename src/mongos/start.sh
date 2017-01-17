#!/bin/bash
cmd=$(/run/mongos/mongos.sh)
if [ "$AUTH" == "y" ] && [ -f /config/key ]; then
  cmd="$cmd --keyFile /config/key"
fi
echo $cmd
$cmd