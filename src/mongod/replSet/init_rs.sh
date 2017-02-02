#!/bin/bash
mongoshell=$(/run/misc/mongoshell.sh)
if [ "$MASTER" != "" ] && [ ! -f /config/.rs_init ]; then
  echo $mongoshell admin --quiet --eval "rs.initiate();"
  $mongoshell admin --quiet --eval "rs.initiate();"
  /run/mongod/replSet/wait_until_rs_configured.sh
  touch /config/.rs_init
fi
