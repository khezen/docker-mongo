#!/bin/bash

mongoshell=$(/run/cmd/mongoshell.sh)
sleep 5
if [ "$RS_NAME" != "" ]; then
  echo $mongoshell --eval "rs.status()"
  $mongoshell --eval "rs.status()"
elif [ "$CONFIG_SERVERS" != "" ]; then
  echo $mongoshell --eval "sh.status()"
  $mongoshell --eval "sh.status()"
fi
