#!/bin/bash
mongoshell=$(/run/misc/mongoshell.sh)
if [ "$MASTER" != "" ] && [ ! -f /data/db/.metadata/.rs_init ]; then
  echo $mongoshell admin --quiet --eval "rs.initiate();"
  $mongoshell admin --quiet --eval "rs.initiate();"
  /run/mongod/replSet/wait_until_rs_configured.sh
  touch /data/db/.metadata/.rs_init
fi
