#!/bin/bash

mongoshell=$(/run/cmd/mongoshell.sh)
sleep 5
if [ "$RS_NAME" != "" ]; then
  echo $mongoshell admin --eval "rs.status()"
  $mongoshell admin --eval "rs.status()"
elif [ "$CONFIG_SERVERS" != "" ]; then
  echo $mongoshell admin --eval "sh.status()"
  $mongoshell admin --eval "sh.status()"
fi
