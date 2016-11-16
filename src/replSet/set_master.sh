#!/bin/bash 
if [ "$MASTER" != "" ] && [ ! -f /config/.master_set ]; then
  echo mongo --quiet --eval "rs.initiate();"
  mongo --quiet --eval "rs.initiate();"
  /run/replSet/wait_until_rs_configured.sh
  echo mongo --quiet --eval "var conf = rs.conf(); conf.members[0].host='$MASTER'; rs.reconfig(conf)"
  mongo --quiet --eval "var conf = rs.conf(); conf.members[0].host='$MASTER'; rs.reconfig(conf)"
  touch /config/.master_set
fi