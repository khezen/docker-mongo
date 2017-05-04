#!/bin/bash
mongoshell=$(/run/misc/mongoshell.sh)
if [ "$MASTER" != "" ] && [ ! -f /data/db/.metadata/.master_set ]; then
  echo $mongoshell admin --quiet --eval "var conf = rs.conf(); conf.members[0].host='$MASTER'; conf.members[0].priority=1000; rs.reconfig(conf)"
  $mongoshell admin --quiet --eval "var conf = rs.conf(); conf.members[0].host='$MASTER';conf.members[0].priority=1000; rs.reconfig(conf)"
  /run/mongod/replSet/wait_until_rs_configured.sh
  touch /data/db/.metadata/.master_set
fi
