#!/bin/bash

mongoshell=$(/run/cmd/mongoshell.sh)
sleep 5
if [ "$rs_name" != "" ]; then
  echo $mongoshell --eval "rs.status()"
  $mongoshell --eval "rs.status()"
elif [ "$config_servers" != "" ]; then
  echo $mongoshell --eval "sh.status()"
  $mongoshell --eval "sh.status()"
fi
